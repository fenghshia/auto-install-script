vpc = [
    "gcloud",
    "beta",
    "compute",
    "--project=emerald-diagram-xxxx",
    "instances",
    "create",
    "fenghshia-test",
    "--zone=asia-east2-a",
    "--machine-type=f1-micro",
    "--subnet=default",
    "--network-tier=PREMIUM",
    "--metadata=\"ssh-keys=fenghshia:ssh-rsa xxxx= fenghshia\"",
    "--maintenance-policy=MIGRATE",
    "--service-account=xxxx-compute@developer.gserviceaccount.com",
    "--tags=auto-set-in,auto-set-out,http-server",
    "--image=ubuntu-2004-focal-v20210129",
    "--image-project=ubuntu-os-cloud",
    "--boot-disk-size=10GB",
    "--boot-disk-type=pd-standard",
    "--boot-disk-device-name=fenghshia-test",
    "--no-shielded-secure-boot",
    "--shielded-vtpm",
    "--shielded-integrity-monitoring",
    "--reservation-affinity=any"
]


def generatescript():
    with open("vpcscript.sh", "w", encoding="utf-8") as f:
        f.write(" ".join(vpc)+"\n")


if __name__ == "__main__":
    generatescript()