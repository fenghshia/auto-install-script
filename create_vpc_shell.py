import re
from copy import deepcopy
from datetime import datetime

class vpccomplete:

    def __init__(self, custom, code):
        # 解析code获取 项目名 账户名
        project_re = '--project=(.*) instances'
        server_account_re = '--service-account=(.*) --scopes='
        image_re = '--image=(.*) --image-project='
        res = re.search(project_re, code, re.M|re.I)
        self.project = res.group(1)
        # 解析custom配置
        self.rules = custom["rules"]
        # 生成防火墙策略
        self.generate_route()
        res = re.search(server_account_re, code, re.M|re.I)
        self.server_account = res.group(1)
        res = re.search(image_re, code, re.M|re.I)
        self.image = res.group(1)
        self.zone = custom["zone"]
        self.code = custom["code"]
        self.machine_type = custom["machine-type"]
        self.disk_size = custom["disk-size"]
        self.generate_vpc()
        self.writetofile()

    def generate_route(self):
        routebase = [
            "gcloud",
            "compute",
            f"--project={self.project}",
            "firewall-rules",
            "create"
        ]

        routein = [
            "auto-set-in",
            "--description=\"auto set route firewall by script\"",
            "--direction=INGRESS",
            "--priority=1000",
            "--network=default",
            "--action=ALLOW",
            f"--rules={self.rules}",
            "--source-ranges=0.0.0.0/0"
        ]

        routeout = [
            "auto-set-out",
            "--description=\"auto set route firewall by script\"",
            "--direction=EGRESS",
            "--priority=1000",
            "--network=default",
            "--action=ALLOW",
            f"--rules={self.rules}",
            "--destination-ranges=0.0.0.0/0"
        ]

        base = deepcopy(routebase)
        base.extend(routein)
        self.routein = " ".join(base)
        base = deepcopy(routebase)
        base.extend(routeout)
        self.routeout = " ".join(base)
    
    def generate_vpc(self):
        vpc = [
            "gcloud",
            "beta",
            "compute",
            f"--project={self.project}",
            "instances",
            "create",
            f"fenghshia-cloud{self.code}",
            f"--zone={self.zone}",
            f"--machine-type={self.machine_type}",
            "--subnet=default",
            "--network-tier=PREMIUM",
            # "--metadata=\"ssh-keys={}\"",
            "--maintenance-policy=MIGRATE",
            f"--service-account={self.server_account}",
            "--tags=auto-set-in,auto-set-out",
            f"--image={self.image}",
            "--image-project=ubuntu-os-cloud",
            f"--boot-disk-size={self.disk_size}GB",
            "--boot-disk-type=pd-standard",
            f"--boot-disk-device-name=fenghshia-cloud{self.code}",
            "--no-shielded-secure-boot",
            "--shielded-vtpm",
            "--shielded-integrity-monitoring",
            "--reservation-affinity=any"
        ]
        
        self.vpc = " ".join(vpc)
    
    def writetofile(self):
        with open("vpcscript.sh", "w", encoding="utf-8") as f:
            f.write(
                f"{self.routein}\n{self.routeout}\n{self.vpc}"
            )


if __name__ == "__main__":
    # 需要改造: 1. 解析命令获取 项目名 账户名 镜像名 --完成
    # 操作步骤: 1. 从gcp复制shell命令
    #          2. 修改custom
    #          3. 运行脚本
    code = ""
    custom = {
        "rules": "tcp:80,tcp:6000-7000,tcp:8000-9000",
        "zone": "asia-east1-a",
        "code": datetime.now().strftime("%H%M%S"),
        "machine-type": "n1-highcpu-2",
        "disk-size": 50
    }

    vpccomplete(custom, code)
