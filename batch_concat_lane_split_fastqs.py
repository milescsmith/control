import re
from pathlib import Path

cwd = Path().cwd()
read1s = list(cwd.glob("*R1*"))

name_pat = r"(.*_S[0-9]+)_L001_R1_001.fastq.gz"
name_set = {re.findall(name_pat, str(_.name))[0] for _ in read1s if "L001" in str(_.name)}

# names = Path("lane12_files.txt").read_text().split("\n")[:-1]

template = """#!/bin/bash -l

#SBATCH -J upload
#SBATCH -o upload.log
#SBATCH --mem=16G
#SBATCH --partition=serial
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
"""

for i in name_set:
    cat_r1 = f"zcat {i}_L001_R1_001.fastq.gz {i}_L002_R1_001.fastq.gz | gzip > ./cat/{i}_R1_001.fastq"
    cat_r2 = f"zcat {i}_L001_R2_001.fastq.gz {i}_L002_R2_001.fastq.gz | gzip > ./cat/{i}_R2_001.fastq"
    with open(f"{i}.sbatch", "w") as o:
        o.write(template + cat_r1 + "\n" + cat_r2)


name_pat2 = r"(.*_S[0-9]+)_L003_R1_001.fastq.gz"
name_set2 = {re.findall(name_pat2, str(_.name))[0] for _ in read1s if "L003" in str(_.name)}


for i in name_set2:
    cat_r1 = f"zcat {i}_L003_R1_001.fastq.gz {i}_L004_R1_001.fastq.gz | gzip > ./cat/{i}_R1_001.fastq"
    cat_r2 = f"zcat {i}_L003_R2_001.fastq.gz {i}_L004_R2_001.fastq.gz | gzip > ./cat/{i}_R2_001.fastq"
    with open(f"{i}.sbatch", "w") as o:
        o.write(template + cat_r1 + "\n" + cat_r2)