#! bin/bash
# Example: ./train "000001.train" '-s 7 -c 4 -w0 0.1 -w1 0.9 -B 10'
fname_train=$1
fname_model=$2
fname_predict=$3
str_train=$4
str_predict=$5
fname_donesignal=$6

echo "fname_train=$fname_train"
echo "fname_model=$fname_model"
echo "fname_predict=$fname_predict"
echo "str_train=$str_train"
echo "str_predict=$str_predict"
echo "fname_donesignal=$fname_donesignal"
rm -f $fname_donesignal

# Run train with inputs
../../../code/src/utils/submodules/liblinear-1.94/train $str_train $fname_train

echo "running next command here"

../../../code/src/utils/submodules/liblinear-1.94/predict $str_predict $fname_train $fname_model $fname_predict


printf 'Done.' >> $fname_donesignal
