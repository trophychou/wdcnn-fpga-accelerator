import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha(path):
    with path.open("rb") as f:
        return hashlib.file_digest(f, "sha256").hexdigest()


def main():
    manifest = json.loads((HERE / "bundle_manifest.json").read_text(encoding="utf-8"))
    if manifest["status"] != "prototype_only_not_full_data_deployment_model":
        raise SystemExit("unexpected bundle status")
    for rel, item in manifest["file_inventory"].items():
        path = HERE / rel
        if not path.is_file() or path.stat().st_size != item["bytes"] or sha(path) != item["sha256"]:
            raise SystemExit(f"bundle file mismatch: {rel}")
    if sha(HERE / "interface_contract.json") != manifest["contract_sha256"]:
        raise SystemExit("interface contract hash mismatch")
    if sha(HERE / "postprocess_contract.json") != manifest["postprocess_contract_sha256"]:
        raise SystemExit("postprocess contract hash mismatch")
    if sha(HERE / "host_cpp_test_result.json") != manifest["host_cpp_test_result_sha256"]:
        raise SystemExit("host C++ test report hash mismatch")
    for name, digest in manifest["hls_source_sha256"].items():
        if sha(HERE / "hls" / name) != digest:
            raise SystemExit(f"HLS source hash mismatch: {name}")
    contract = json.loads((HERE / "interface_contract.json").read_text(encoding="utf-8"))
    for branch, channels in (("vibration", 5), ("current", 2)):
        root = HERE / "prototype_fold01" / branch
        graph = json.loads((root / "graph.json").read_text(encoding="utf-8"))
        fpga = root / "fpga_binary"
        if graph["input_shape"] != ["batch", channels, 5120]:
            raise SystemExit(f"{branch}: graph input shape mismatch")
        if graph["layers"][-1]["weight_shape"] != [3, 100]:
            raise SystemExit(f"{branch}: classifier shape mismatch")
        expected = {
            "weights_int8.bin": sum(int(x["weight_shape"][0]) * int(x["weight_shape"][1]) *
                                    (int(x["weight_shape"][2]) if len(x["weight_shape"]) == 3 else 1)
                                    for x in graph["layers"]),
            "biases_int32_le.bin": 343 * 4,
            "multipliers_int32_le.bin": 343 * 4,
            "shifts_int32_le.bin": 343 * 4,
            "input_int8.bin": 4 * channels * 5120,
            "fc2_output_int8.bin": 4 * 3,
        }
        for name, size in expected.items():
            if (fpga / name).stat().st_size != size:
                raise SystemExit(f"{branch}: bad size for {name}")
    if contract["input"]["vibration"]["shape"] != [5, 5120] or contract["input"]["current"]["shape"] != [2, 5120]:
        raise SystemExit("interface contract shape mismatch")
    fusion = json.loads((HERE / "postprocess_contract.json").read_text(encoding="utf-8"))
    if fusion["status"] != "training_oof_selected_for_outer_fold_01_prototype_only":
        raise SystemExit("unexpected postprocess model scope")
    test = json.loads((HERE / "host_cpp_test_result.json").read_text(encoding="utf-8"))
    if test["status"] != "pass" or test["mismatches"] != 0 or test["logits_compared"] != 24:
        raise SystemExit("unexpected host C++ test result")
    print(f"PASS: {len(manifest['file_inventory'])} prototype files, {len(manifest['hls_source_sha256'])} HLS sources, and host test evidence verified.")


if __name__ == "__main__":
    main()
