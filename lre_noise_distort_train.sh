for ((var=0; var<3; var++))
do   
    if [ $var -eq 0 ]; then
        SEED=729
    elif [ $var -eq 1 ]; then
        SEED=492
    elif [ $var -eq 2 ]; then
        SEED=139
    elif [ $var -eq 3 ]; then
        SEED=692
    elif [ $var -eq 4 ]; then
        SEED=396
    fi

    for ((DISTORT=4; DISTORT<6; DISTORT++))
    do
        MODEL=ninasr_b0
        TODAY=$(date +"%Y%m%d")
        SHIFT=1
        ROTATE=1
        NOISE=DISTORT
        BS=256
        LR=1e-3
        CHECK_FILE=2x_bs${BS}_300epochs_l1_div2k_bicubic_${NOSIE}${DISTORT}_lre_higher_${var}
        WORK_FILE=2x_bs${BS}_300epochs_l1_div2k_bicubic_${NOISE}Albu${DISTORT}_960_batch_lre_higher_${TODAY}_${var}
        python -m torchsr.train --arch $MODEL \
                                --scale 2 \
                                --batch-size ${BS} \
                                --lr ${LR} \
                                --epochs 300 \
                                --lre True \
                                --batch-reweight True \
                                --index-patch True \
                                --noise ${NOISE} \
                                --shift ${SHIFT} \
                                --rotate ${ROTATE} \
                                --distort ${DISTORT} \
                                --loss l1 \
                                --dataset-train div2k_bicubic \
                                --save-checkpoint ./workdirs/${MODEL}/${NOISE}/LRE/${WORK_FILE}.pt \
                                --load-checkpoint ./workdirs/${MODEL}/${NOISE}/${CHECK_FILE}_e150.pt \
                                --seed ${SEED} \
                                --log ./workdirs/${MODEL}/${NOISE}/LRE/${WORK_FILE}.txt
#                        --load-checkpoint ./workdirs/${MODEL}/${CHECK_FILE}_best.pt \
#                        --batch-size 8 \
#                        --load-checkpoint ./workdirs/ninasr_b1/${CHECK_FILE}_best.pt \
#                        --validation-only \
# python -m torchsr.train --arch ninasr_b1 \
#                         --scale 2 \
#                         --epochs 300 \
#                         --loss l1 \
#                         --dataset-train div2k_bicubic \
#                         --log ./workdirs/ninasr_b1/test.txt
    done
done 
