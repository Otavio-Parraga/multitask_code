import torch
from utils import set_seed
from models import Code2TestModel, load_seq2seq_model_and_tokenizer, MultiTaskModel
from datasets import Code2TestDataset
from torch.utils.data import DataLoader
from tqdm import tqdm
from metrics import bleu, tokenized_bleu, alpha_bleu
from utils import dict_to_device, set_seed
import json
from pathlib import Path
from args import parse_code2test_args


def postprocess_text(preds, labels):
    preds = [pred.strip() for pred in preds]
    labels = [label.strip() for label in labels]

    return preds, labels


if __name__ == '__main__':
    # TODO: Need to fix the method so that the new line error do not happen
    args = parse_code2test_args('eval')

    set_seed()
    pretrained_model_name = args.pretrained_model
    checkpoint_path = args.checkpoint_path
    output_dir = Path('/'.join(checkpoint_path.split('/')[:-1]))
    pretrained_model, tokenizer = load_seq2seq_model_and_tokenizer(
            pretrained_model_name)
    if args.is_multitask:
        model = MultiTaskModel.load_from_checkpoint(checkpoint_path=checkpoint_path,
                                                    pretrained_model=pretrained_model,
                                                    tokenizer=tokenizer, cache_path='./pretrained_stuff')
    else:
        model = Code2TestModel.load_from_checkpoint(
            checkpoint_path=checkpoint_path, pretrained_model=pretrained_model, tokenizer=tokenizer, cache_path='./pretrained_stuff')
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    dataset = Code2TestDataset(split='test', tokenizer=tokenizer, prefix=args.prefix)
    dataloader = DataLoader(dataset, batch_size=216, shuffle=False)

    model.eval()
    model.to(device)

    bleu_score, tokenized_bleu_score, alpha_bleu_score = 0, 0, 0
    preds, ground_truths = [], []

    with torch.no_grad():
        for i, batch in enumerate(tqdm(dataloader)):
            source, target = batch
            source, target = dict_to_device(
                source, device), dict_to_device(target, device)

            output = model.generate(input_ids=source['input_ids'],
                                    attention_mask=source['attention_mask'],
                                    do_sample=True, max_length=128)

            output = tokenizer.batch_decode(output, skip_special_tokens=True)
            labels = tokenizer.batch_decode(
                target['input_ids'], skip_special_tokens=True)
            output, labels = postprocess_text(output, labels)

            preds.extend(output)
            ground_truths.extend(labels)
            assert len(preds) == len(ground_truths)

            if i % 5 == 0:
                print(
                    f'BLEU: {bleu(preds, ground_truths)} CodeBLEU: {tokenized_bleu(preds, ground_truths, tokenizer)} AlphaBLEU: {alpha_bleu(preds, ground_truths)}')

    with open(output_dir / 'code2test_metrics.json', 'w') as f:
        json.dump({'bleu': bleu(preds, ground_truths),
                   'code_bleu': tokenized_bleu(preds, ground_truths, tokenizer),
                   'alpha_bleu': alpha_bleu(preds, ground_truths)}, f)

    # with open(output_dir / 'predictions.txt', 'w') as f:
    #     f.write('\n'.join(preds))

    # with open(output_dir / 'ground_truths.txt', 'w') as f:
    #     f.write('\n'.join(ground_truths))
    
    with open(output_dir / 'predictions_array.txt', 'w') as f:
        f.write(str(preds))

    with open(output_dir / 'ground_truths_array.txt', 'w') as f:
        f.write(str(ground_truths))
