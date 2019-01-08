#pull SNPs with weights in the ASN.db predictor
#by Angela Andaleon (aandaleon)
import sqlite3
import pandas
gene_output = []
conn = sqlite3.connect("/home/elyse/Cebu_test/Cebu_test/Asian_10_peer_10_pcs_filtered.db")
c = conn.cursor()
c.execute('select * from weights;')
for row in c:
  gene_output.append([row[1]])
conn.close()
gene_output_df = pandas.DataFrame(gene_output, columns = ['rs'])
gene_output_df.to_csv("/home/angela/pop_exp_pred/SNPs_in_Asian.db.txt", index = False)
