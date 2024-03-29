from torch.utils.data import DataLoader
from args import parse_codesearch_args
from datasets import CodeSearchNetDataset
from models import CodeSearchModel, load_tokenizer, load_seq2seq_model_and_tokenizer, MultiTaskModel
from pathlib import Path
from tqdm import tqdm
import torch
from metrics import mrr
from utils import dict_to_device, set_seed
import json


if __name__ == '__main__':
    set_seed()

    args = parse_codesearch_args('eval')
    data_dir = Path(args.data_dir)
    language = args.language
    pretrained_model = args.pretrained_model
    partitions = ['test', 'valid']
    output_dir = Path('/'.join(args.checkpoint_path.split('/')[:-1]))
    if args.is_multitask:
        model_base, tokenizer = load_seq2seq_model_and_tokenizer(
            pretrained_model)
        model = MultiTaskModel.load_from_checkpoint(checkpoint_path=args.checkpoint_path,
                                                    pretrained_model=model_base,
                                                    tokenizer=tokenizer)
    else:
        model = CodeSearchModel.load_from_checkpoint(checkpoint_path=args.checkpoint_path,
                                                 model_name=pretrained_model, cache_path='./pretrained_stuff')
    tokenizer = load_tokenizer(model_name=pretrained_model, cache_path='./pretrained_stuff')
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    model.to(device)
    model.eval()

    with torch.no_grad():
        metrics = {}
        for partition in partitions:
            eval_dataset = CodeSearchNetDataset(data_dir, split=partition, tokenizer=tokenizer, prefix=args.prefix, language=language)
            eval_loader = DataLoader(eval_dataset, batch_size=32, shuffle=False)

            queries, values, query_idxs, value_idxs = [], [], [], []
            for batch in tqdm(eval_loader):
                code, comment, url = batch
                code = dict_to_device(code, device)
                comment = dict_to_device(comment, device)
                value, query = model(code, comment)
                query_idxs.extend(url)
                value_idxs.extend(url)

                queries.append(query.cpu().data)
                values.append(value.cpu().data)

            queries = torch.cat(queries, dim=0)
            values = torch.cat(values, dim=0)

            mrr_value = mrr(queries.data.numpy(), values.data.numpy(), query_idxs, value_idxs)
            metrics[partition] = mrr_value

        with open(output_dir / f'codesearch_{language}_metrics.json', 'w') as f:
            json.dump(metrics, f)