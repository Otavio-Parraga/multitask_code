export CUDA_DEVICE_ORDER=PCI_BUS_ID
PTM="Salesforce/codet5-base"
PTM_NAME="Salesforce-codet5-base"

# =========================================== 50k ================================================
EXP_NAME="ablation_50k_iters"
CHECKPOINT_PATH="/home/parraga/projects/_masters/multitask_code/checkpoints/multitask/${EXP_NAME}/${PTM_NAME}/best_model.ckpt"

# Train
CUDA_VISIBLE_DEVICES=0,2 python main_multitask.py -ptm $PTM --batch_size 12 --gpus 2 --prefix \
--tasks codesearch code2test clone generation defect refine translate summarization -i 50000 \
--cs_lang javascript ruby go java python php --sum_lang javascript ruby go java python php \
--output_dir $EXP_NAME

# Eval on codeserach
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang go -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang java -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang javascript -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang php -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang python -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang ruby -ptm $PTM -mt --prefix
# Eval on code2test
CUDA_VISIBLE_DEVICES=0 python eval_code2test.py -ptm $PTM -ckpt $CHECKPOINT_PATH -mt --prefix

# =========================================== 100k ================================================
EXP_NAME="ablation_100k_iters"
CHECKPOINT_PATH="/home/parraga/projects/_masters/multitask_code/checkpoints/multitask/${EXP_NAME}/${PTM_NAME}/best_model.ckpt"

# Train
CUDA_VISIBLE_DEVICES=0,2 python main_multitask.py -ptm $PTM --batch_size 12 --gpus 2 --prefix \
--tasks codesearch code2test clone generation defect refine translate summarization -i 100000 \
--cs_lang javascript ruby go java python php --sum_lang javascript ruby go java python php \
--output_dir $EXP_NAME

# Eval on codeserach
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang go -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang java -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang javascript -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang php -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang python -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang ruby -ptm $PTM -mt --prefix
# Eval on code2test
CUDA_VISIBLE_DEVICES=0 python eval_code2test.py -ptm $PTM -ckpt $CHECKPOINT_PATH -mt --prefix

# =========================================== 150k ================================================
EXP_NAME="ablation_150k_iters"
CHECKPOINT_PATH="/home/parraga/projects/_masters/multitask_code/checkpoints/multitask/${EXP_NAME}/${PTM_NAME}/best_model.ckpt"

# Train
CUDA_VISIBLE_DEVICES=0,2 python main_multitask.py -ptm $PTM --batch_size 12 --gpus 2 --prefix \
--tasks codesearch code2test clone generation defect refine translate summarization -i 150000 \
--cs_lang javascript ruby go java python php --sum_lang javascript ruby go java python php \
--output_dir $EXP_NAME

# Eval on codeserach
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang go -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang java -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang javascript -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang php -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang python -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang ruby -ptm $PTM -mt --prefix
# Eval on code2test
CUDA_VISIBLE_DEVICES=0 python eval_code2test.py -ptm $PTM -ckpt $CHECKPOINT_PATH -mt --prefix

# =========================================== 200k ================================================
EXP_NAME="ablation_200k_iters"
CHECKPOINT_PATH="/home/parraga/projects/_masters/multitask_code/checkpoints/multitask/${EXP_NAME}/${PTM_NAME}/best_model.ckpt"

# Train
CUDA_VISIBLE_DEVICES=0,2 python main_multitask.py -ptm $PTM --batch_size 12 --gpus 2 --prefix \
--tasks codesearch code2test clone generation defect refine translate summarization -i 200000 \
--cs_lang javascript ruby go java python php --sum_lang javascript ruby go java python php \
--output_dir $EXP_NAME

# Eval on codeserach
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang go -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang java -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang javascript -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang php -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang python -ptm $PTM -mt --prefix
CUDA_VISIBLE_DEVICES=0 python eval_codesearch.py -ckpt $CHECKPOINT_PATH -lang ruby -ptm $PTM -mt --prefix
# Eval on code2test
CUDA_VISIBLE_DEVICES=0 python eval_code2test.py -ptm $PTM -ckpt $CHECKPOINT_PATH -mt --prefix