##filtering out Imputation results, adapted from https://www.biostars.org/p/205856/ 
##changes Imputation results into PLINK format

from __future__ import division
import gzip
import re
import sys
from collections import defaultdict

for chnum in {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22}
   do
  gunzip chr$chnum.info.gz
  plink --vcf chr$chnum.dose.vcf.gz --make-bed --out s1
  plink --bfile s1 --bmerge s1 --merge-mode 6
  plink --bfile s1 --exclude plink.missnp --make-bed --out s2
  plink --bfile s2 --list-duplicate-vars
  plink --bfile s2 --exclude plink.dupvar --make-bed --out s3
  plink --bfile s3 --qual-scores chr$chnum.info 7 1 1 --qual-threshold 0.8 --maf 0.01 --allow-no-sex --make-bed --out ../plinkout/chr$chnum
done
