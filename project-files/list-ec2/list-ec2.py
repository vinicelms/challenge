#!/bin/python3

import boto3
import logging
import argparse
import re
from prettytable import PrettyTable

logger = logging.getLogger('list-ec2')
logger.setLevel(logging.INFO)
handler = logging.StreamHandler()
handler.setFormatter(logging.Formatter('%(asctime)-15s %(levelname)-8s %(message)s'))
logger.addHandler(handler)

class EC2:

    def __init__(self, region):
        logger.info("Iniciando sessão para coleta de informações EC2")
        self.client = boto3.Session().client('ec2', region_name=region)
        self.region = region
        self.instance_list = []

    def get_instances(self, filter=None):
        logger.info("Listando instâncias EC2")
        if filter:
            ec2_instances = self.client.describe_instances(
                Filters=[{'Name': 'instance-state-name', 'Values': filter}]
            )
        else:
            ec2_instances = self.client.describe_instances()

        logger.info("Iniciando processamento das instâncias...")
        for instances in ec2_instances['Reservations']:
            for instance in instances['Instances']:
                ec2_instance = EC2Instance()
                ec2_instance.instance_info(instance=instance)
                self.instance_list.append(ec2_instance)

        return self.instance_list

class EC2Instance:

    def __init__(self):
        self.id = None
        self.name = None
        self.type = None
        self.private_ip = None
        self.public_ip = None
        self.state = None
        self.tags = []
        TAG_NOT_USED = '^aws:.*'

    def instance_info(self, instance):
        self.id = instance['InstanceId']
        self.type = instance['InstanceType']
        self.state = instance['State']['Name']
        if 'PrivateIpAddress' in instance:
            self.private_ip = instance['PrivateIpAddress']
        if 'PublicIpAddress' in instance:
            self.public_ip = instance['PublicIpAddress']
        if instance['Tags']:
            self.__get_tags(tags=instance['Tags'])

    def __get_tags(self, tags):
        for tag in tags:
            if not re.search('^aws:.*', tag['Key']):
                self.tags.append(tag)
            if tag['Key'] == 'Name':
                self.name = tag['Value']

if __name__ == "__main__":
    instance_states_allowed = ['pending', 'running', 'shutting-down', 'terminated', 'stopping', 'stopped']
    parser = argparse.ArgumentParser()
    parser.add_argument('--region', help='Informe a região que desta listar as instâncias. Exemplo: us-east-1',
        required=True, action='store', dest='region')
    parser.add_argument('--state', required=False, action='store', dest='states', nargs='+',
        help="Informe o estado desejado das instâncias. Valores possíveis: {}".format(", ".join(instance_states_allowed)))
    parser.add_argument('-as-json', required=False, action='store_true', help="Caso deseje a saída como JSON, utilize esta flag")

    args = parser.parse_args()

    ec2 = EC2(region=args.region)

    if args.states:
        filter_states = []
        for state in args.states:
            if state in instance_states_allowed:
                filter_states.append(state)
            else:
                logger.info("O estado \"{}\" não está disponível para listagem".format(state))

        instances = ec2.get_instances(filter=filter_states)
    else:
        instances = ec2.get_instances()

    table = PrettyTable()
    table.field_names = instances[0].__dict__.keys()
    for instance in instances:
        dict_obj = instance.__dict__
        row_data = []
        for field in table.field_names:
            if field == 'tags':
                content_data = []
                for item in dict_obj[field]:
                    content_data.append("{}: {}".format(item['Key'], item['Value']))
                row_data.append(", ".join(content_data))
            else:
                if dict_obj[field]:
                    row_data.append(dict_obj[field])
                else:
                    row_data.append("-")
        table.add_row(row_data)

    if args.as_json:
        print("\n{}\n".format(table.get_json_string()))
    else:
        print("\n{}\n".format(table))