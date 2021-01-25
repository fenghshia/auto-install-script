from copy import deepcopy


routebase = [
    "gcloud",
    "compute",
    "--project={}",
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
    "--rules={}",
    "--source-ranges=0.0.0.0/0"
]

routeout = [
    "auto-set-out",
    "--description=\"auto set route firewall by script\"",
    "--direction=EGRESS",
    "--priority=1000",
    "--network=default",
    "--action=ALLOW",
    "--rules={}",
    "--destination-ranges=0.0.0.0/0"
]

vpc = [
    "gcloud",
    "beta",
    "compute",
    "--project={}",
    "instances",
    "create",
    "fenghshia-cloud",
    "--zone={}",
    "--machine-type=n1-highcpu-2",
    "--subnet=default",
    "--network-tier=PREMIUM",
    "--metadata=\"ssh-keys={}\"",
    "--maintenance-policy=MIGRATE",
    "--service-account={}",
    "--tags=auto-set-in,auto-set-out,http-server",
    "--image=ubuntu-2004-focal-v20210119a",
    "--image-project=ubuntu-os-cloud",
    "--boot-disk-size={}GB",
    "--boot-disk-type=pd-standard",
    "--boot-disk-device-name=fenghshia-cloud",
    "--no-shielded-secure-boot",
    "--shielded-vtpm",
    "--shielded-integrity-monitoring",
    "--reservation-affinity=any"
]


def setroutein(project, rules):
    base = deepcopy(routebase)
    base[2] = base[2].format(project)
    routein[6] = routein[6].format(rules)
    base.extend(routein)
    return " ".join(base)


def setrouteout(project, rules):
    base = deepcopy(routebase)
    base[2] = base[2].format(project)
    routeout[6] = routeout[6].format(rules)
    base.extend(routeout)
    return " ".join(base)


def setvpc(project, zone, sshkey, account, disk_size):
    vpc[3] = vpc[3].format(project)
    vpc[7] = vpc[7].format(zone)
    vpc[11] = vpc[11].format(sshkey)
    vpc[13] = vpc[13].format(account)
    vpc[18] = vpc[18].format(disk_size)
    return " ".join(vpc)

def generatescript(project, rules, zone, sshkey, account, disk_size):
    with open("vpcscript.sh", "w", encoding="utf-8") as f:
        f.write(
            setroutein(project, rules)+"\n"+setrouteout(project, rules)+"\n"+\
                setvpc(project, zone, sshkey, account, disk_size)+"\n"
        )

if __name__ == "__main__":
    project = "emerald-diagram-300803"
    rules = "tcp:6000-7000,tcp:5050"
    zone = "asia-east1-a"
    sshkey = "fenghshia:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEHXZnPOizU6u/RzKKrt5v/P7a8CitTu3U/50h/JpX1jttlzd0PTqNpuSaJrzo8Kj32Tit2/80O1jXxPcmsvHG7ZsuOFrYRN16rgWTNWauAT9oHuFwq7xFEbAivcTYpIEEfAYfRjOEzLwDjEfHorempsWRMasjHiPeHfUlwAxeLdJsaV0bQdPtNhcm/MAFr80U8ynUovLICgAD3VBVRJxH5WWMJ8GVWSLBDuIdbovw5mNVXs7iurdFwY3qcy3nmbVfmBRyN4/YXNX55W2OtpWE16UeWTJmVeXNxHi5fnOB73nqFWnPlURkiHWTuH4BGHB0/8EWFHnf/X/Ai4OrpbQj6Uxxs1gaIh4f6fjc/I12HDMqL3K/VVg18HfGJYeEHhAY/jziMnRnAaTUkKo3xSoE6K7dNVm/NDVg1/MGhYNSvLqeROWlTENqVZE3RO0fojd1i08BHnBVRVDkPf3DxAkk8utUWqeXUVIxRs4K2TZ2Dc6KzUBJdpf4CLOdHZq6ee0= fenghshia"
    account = "942059884479-compute@developer.gserviceaccount.com"
    disk_size = 10

    generatescript(project, rules, zone, sshkey, account, disk_size)