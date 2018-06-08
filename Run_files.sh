
for pop in  'CHB' 'GIH' 'JPT' 'LWK' 'MKK' 'MEX' 'YRI'
do
        for (( j = 1 ; j <= 22; j++))
        do
        python /home/jennifer/new_PredDB/elastic_net/make_files_PredictDB_new.py $pop ${j}
        done
done
