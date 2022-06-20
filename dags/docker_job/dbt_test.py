from __future__ import print_function

import os
from datetime import datetime, timedelta

from airflow import DAG
from airflow.hooks.postgres_hook import PostgresHook
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator


def file_path(relative_path):
    dir = os.path.dirname(os.path.abspath(__file__))
    split_path = relative_path.split("/")
    new_path = os.path.join(dir + "/data", *split_path)
    return new_path


def csv_to_postgres(**kwargs):
    pg_conn = PostgresHook(postgres_conn_id=kwargs['conn_str'])
    for file, table in zip(kwargs['source_file'], kwargs['table_name']):
        with pg_conn.get_conn() as conn:
            with conn.cursor() as cur:
                pg_conn.bulk_load(table, file_path(file))


def create_dag(dag_id,
               schedule,
               dbt_model,
               description,
               start_date,
               default_args):

    dag = DAG(schedule_interval=schedule,
              default_args=default_args,
              description=description,
              dag_id=dag_id,
              start_date=start_date,
              catchup=False,
              template_searchpath=['/opt/airflow/dag']
              )

    with dag:
        create_source_tables = PostgresOperator(
            task_id="create_source_tables",
            postgres_conn_id='source',
            sql="""sql/create_source_table.sql"""
        )
        create_target_tables = PostgresOperator(
            task_id="create_target_tables",
            postgres_conn_id='target',
            sql="""sql/create_target_table.sql"""
        )
        files_cp = PythonOperator(
            task_id='csv_to_database',
            provide_context=True,
            python_callable=csv_to_postgres,
            op_kwargs={'source_file': ["users.csv", "walls.csv"],
                       'table_name': ["analytics_stage.users_cdc", "analytics_stage.walls_cdc"],
                       'conn_str': 'target'},
        )
        dbt_cleanup = BashOperator(
            task_id=f'dbt_cleanup-{dbt_model}',
            bash_command=f"rm -rf /tmp/{dbt_model} && rm -rf /tmp/tmp* 2>/dev/null || exit 0"
        )
        create_source_tables >> create_target_tables >> files_cp >> dbt_cleanup

    return dag


dbt_models = ["cdc_load"]
for dbt_mdl in dbt_models:
    default_args = {
        'depends_on_past': False,
        'email': ['samuelolle@yahoo.com'],
        'email_on_failure': False,
        'email_on_retry': False,
        'retries': 1,
        'retry_delay': timedelta(minutes=2),
        'execution_timeout': timedelta(seconds=2000),
    }
    description = f'A {dbt_mdl} DAG '
    schedule_interval = timedelta(hours=2)
    dag_id = f'T-dbt-job-{dbt_mdl}'
    start_date = datetime(2022, 4, 1)

    globals()[dag_id] = create_dag(dag_id=dag_id,
                                   schedule=schedule_interval,
                                   dbt_model=dbt_mdl,
                                   description=description,
                                   start_date=start_date,
                                   default_args=default_args)
