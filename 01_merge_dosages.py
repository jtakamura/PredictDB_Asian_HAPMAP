##from Lauren S. Mogil###
from __future__ import division
import gzip
import re
import sys
from collections import defaultdict
chr= "22"
#chr =sys.argv[1]
jpt_dosage ="/home/jennifer/New_Dosages/JPT/JPT_"+chr+".dosage.txt.gz"
chb_dosage="/home/jennifer/New_Dosages/CHB/CHB_"+chr+".dosage.txt.gz"
#outfile=gzip.open("/home/lauren/mesa_dosages/imp2_ALL_chr"+c+"_ref1kg_dosage.txt.gz","wb")
refdict = defaultdict(set)
for i in gzip.open(jpt_dosage):
    afad = i.strip().split() #split by white space
    (chra, rsida, posa, a1a, a2a,mafa) = afad[0:6] #assign first 5 indices
    adose = afad[6:]
    adose = str(afad[6:])
    adose = adose.replace("[", "")
    adose = adose.replace("]", "")
    refdict[rsida].add(adose)
    
#o = [] 
ofile=open("/home/jennifer/Asian_"+chr+ "_Dosages.txt","wb")
for j in gzip.open(chb_dosage):
    caud = j.strip().split() #split by white space
    (chrc, rsidc, posc, a1c, a2c,mafc) = caud[0:6] #assign first 5 indices
    cdose =caud[6:]
    cdose =str(caud[6:])
    cdose = cdose.replace("[", "")
    cdose = cdose.replace("]", "")
    cdose = cdose.replace("'", "")
    cdose = cdose.replace(",", " ")
    if caud[1] in refdict:
        ad = refdict[caud[1]]
        ad=map(str, ad)
        ad=str(ad)
        ad=ad.replace("[", "")
        ad=ad.replace("]", "")
        ad=ad.replace('"', "")
        ad=ad.replace("'", "")
        ad=ad.replace(",", " ")
        out= chrc+ ' '+rsidc+ ' '+posc+ ' '+a1c+ ' '+a2c+ ' '+mafc+' '+ad+ ' '+cdose+ '\n'
        ofile.write(out)
    
ofile.close() 
