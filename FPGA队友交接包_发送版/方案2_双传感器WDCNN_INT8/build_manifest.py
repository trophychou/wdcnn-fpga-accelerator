import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def sha(path):
    with path.open("rb") as f:
        return hashlib.file_digest(f, "sha256").hexdigest()


def main():
    proto = ROOT / "prototype_fold01"
    files = {}
    for path in sorted(proto.rglob("*")):
        if path.is_file():
            files[path.relative_to(ROOT).as_posix()] = {
                "bytes": path.stat().st_size,
                "sha256": sha(path),
            }
    branches = []
    for branch in ("vibration", "current"):
        graph = proto / branch / "graph.json"
        branches.append({"branch": branch, "graph_sha256": sha(graph)})
    manifest = {
        "status": "prototype_only_not_full_data_deployment_model",
        "fold": 1,
        "testbench_vectors_per_branch": 4,
        "branches": branches,
        "file_inventory": files,
        "contract_sha256": sha(ROOT / "interface_contract.json"),
        "postprocess_contract_sha256": sha(ROOT / "postprocess_contract.json"),
        "host_cpp_test_result_sha256": sha(ROOT / "host_cpp_test_result.json"),
        "hls_source_sha256": {
            path.name: sha(path) for path in sorted((ROOT / "hls").glob("*")) if path.is_file()
        },
    }
    (ROOT / "bundle_manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    print(f"Manifest written: {len(files)} model files, {len(manifest['hls_source_sha256'])} HLS source files.")


if __name__ == "__main__":
    main()
