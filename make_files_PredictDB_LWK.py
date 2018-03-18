###Lauren S. Mogil###
###make MESA data in the correct format for predictDB###

import gzip
import sys

pop=sys.argv[1]
chr=sys.argv[2]

#pop='LWK'
#chr='22'

######change file paths to fit your data 
dosage = "/home/jennifer/New_Dosages/"+pop+"/"+pop+"_"+chr+".dosage.txt"
samples="/home/jennifer/New_Dosages/"+pop+"/samples_"+pop+".txt"


anot_file=gzip.open("/home/jennifer/"+pop+"/annot_file/"+pop+"_"+chr+"_SNPs_Location.txt.gz","wb")
snp_file=gzip.open("/home/jennifer/"+pop+"/snp_file/"+pop+"_"+chr+"_SNP.txt.gz","wb")


########
anot_file.write('Chr'+'\t'+'pos'+'\t'+'var_id'+'\t'+'ref_a1'+'\t'+'alt_a2'+'\t'+'snp_id'+'\t'+'RSID_dbSNP137'+'\t'+'num_alt'+'\n')

samp=[]
for sam in open(samples):
	s=sam.strip().split()
	s1=s[0]
	samp.append(s1)
	
	
samp1 = str(samp) #convert to string
splitheader = samp1.replace("'", "") #format and remove extra characters
splitheader = splitheader.replace("]", "")
splitheader = splitheader.replace("[", "")
splitheader = splitheader.replace(" ", "")
splitheader = splitheader.replace(",", "\t") #make tab delim file 
head = "id\t" + splitheader #add label for ids
snp_file.write(head + "\n")
	
for line in open(dosage):
	arr=line.strip().split()
	(c, rs, pos, a1, a2, maf)=arr[0:6]
	dose=arr[6:]
	varid= chr+'_'+pos+'_'+a1+'_'+a2+'_'+'b37'
	snpid='snp'+'_'+chr+'_'+pos
	dosages = '\t'.join(map(str,dose))
	snp= varid+'\t'+dosages+'\n'
	annot= chr+'\t'+pos+'\t'+varid+'\t'+a1+'\t'+a2+'\t'+snpid+'\t'+rs+'\t'+'1'+'\n'
	anot_file.write(annot)
	snp_file.write(snp)
	
	
	
anot_file.close()
snp_file.close()
