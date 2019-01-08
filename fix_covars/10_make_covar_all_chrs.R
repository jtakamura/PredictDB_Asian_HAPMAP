#concatenate covariance files while filtering by inclusion in .db file, matching chrs., and covariance to self
#by Angela Andaleon (aandaleon)
"%&%" = function(a,b) paste(a,b,sep="")
library(data.table)
library(dplyr)

all_covar <- data.frame(GENE = character(), RSID1 = character(), RSID2 = character(), VALUE = numeric(), gene_chr = numeric(), stringsAsFactors = F) #to collect results of all covariance files

for(chr in 1:22){
  chr_annot <- fread("/home/angela/pop_exp_pred/new_PredDB/elastic_net/prepare_data/genotypes/Asian_annot.chr" %&% chr %&% ".txt") #read in individual chrs' annotation files
    #FILE FORMAT:
    #chr     pos     varID   refAllele       effectAllele    rsid
    #22      16504399        22_16504399_C_T_b37     C       T       rs4911642
    #22      16504491        22_16504491_G_A_b37     G       A       rs6010340
  chr_annot <- chr_annot %>% dplyr::select(rsid, chr) #need only rsid and chr for matching later
  
  #add chr info of all SNPs
  chr_annot_RSID1 <- chr_annot
  colnames(chr_annot_RSID1) <- c("RSID1", "chr_RSID1")
  chr_annot_RSID2 <- chr_annot
  colnames(chr_annot_RSID2) <- c("RSID2", "chr_RSID2")
  rm(chr_annot)
  
  #add chr information for all covar SNPs and genes
  chr_covar <- fread("/home/angela/pop_exp_pred/new_PredDB/elastic_net/outputs/ASN_covars/Asian_nested_cv_chr" %&% chr %&% "_covariances_10_peer_10pcs.txt")
    #FILE FORMAT:
	#GENE RSID1 RSID2 VALUE
    #ENSG00000198445.3 rs9606615 rs9606615 0.311788964189863
    #ENSG00000198445.3 rs9606615 rs4819959 0.0100814715129208
  chr_covar$gene_chr <- as.numeric(chr)
  chr_covar <- left_join(chr_covar, chr_annot_RSID1, by = "RSID1")
  chr_covar <- left_join(chr_covar, chr_annot_RSID2, by = "RSID2")
  all_covar <- rbind(all_covar, chr_covar) #add to overall table
}

#troubleshooting using FAQ from https://github.com/hakyimlab/MetaXcan/wiki/FAQ,-Troubleshooting-and-Common-Issues

#"if you are building custom covariance matrices, check that all SNP covariance entries for a gene have a SNP entry in the model"
#restrict to just SNPs w/ weights in the ASN.db
ASN_db_SNPs <- fread("/home/angela/pop_exp_pred/SNPs_in_Asian.db.txt")$rs #read in list of SNPs in .db
  #FILE FORMAT: 
  #rs
  #rs75998592
  #rs79361728
all_covar_in_db <- subset(all_covar, RSID1 %in% ASN_db_SNPs & RSID2 %in% ASN_db_SNPs) #restrict to just SNPs in .db

#"MetaXcan currently assumes that 'cis' snps are relevant. 'Trans' locality is something we haven't finished analyzing yet"
#if gene chr and snp chr aren't the same, throw out
no_duplicate_cols <- c("gene_chr", "chr_RSID1", "chr_RSID2") #columns to compare
all_covar_cis <- all_covar_in_db[duplicated(all_covar_in_db[, no_duplicate_cols]),] #https://stackoverflow.com/questions/47780203/delete-rows-if-column-values-are-equal-in-r

#runs into an error with SNPs that do not have covariances to themselves
#make list of SNPs that have covariances with themselves and subset to that
no_duplicate_cols <- c("RSID1", "RSID2")
all_covar_cis$rep_w_self <- all_covar_cis$RSID1 == all_covar_cis$RSID2 #see previous step
keep_rep_w_self <- subset(all_covar_cis, rep_w_self == TRUE)$RSID1
all_covar_rep_w_self <- subset(all_covar, RSID1 %in% keep_rep_w_self & RSID2 %in% keep_rep_w_self) #keep those that have rep with self
all_covar_rep_w_self$gene_chr <- NULL #chr cols. now unnecessary
all_covar_rep_w_self$chr_RSID1 <- NULL
all_covar_rep_w_self$chr_RSID2 <- NULL

#"assumed to contain all SNP entries for a given gene in a contiguous matter"
#sort by gene? Why didn't they just say sorted?
all_covar_sorted <- all_covar_rep_w_self[order(all_covar_rep_w_self$GENE, all_covar_rep_w_self$RSID1),] #order by gene then SNP in gene
fwrite(all_covar_sorted, "/home/angela/pop_exp_pred/ASN_covar_troubleshooted.txt", row.names = F, col.names = T, quote = F, sep = "\t", na = "NA", nThread = 10) #hooray now you have a not broken covariance file