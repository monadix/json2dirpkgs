import unittest

from measure import normalize_info, summarize


class MeasurementTests(unittest.TestCase):
    def test_shared_runtime_is_counted_once(self):
        shared = {"narSize": 100}
        packages = [
            {"status": "built", "outputs": ["/a"], "closure": {"/a": {"narSize": 10}, "/runtime": shared}},
            {"status": "built", "outputs": ["/b"], "closure": {"/b": {"narSize": 20}, "/runtime": shared}},
            {"status": "build-failed"},
        ]
        summary, union = summarize(packages)
        self.assertEqual(summary["runtimeUnionNarBytes"], 130)
        self.assertEqual(summary["packageOutputNarBytes"], 30)
        self.assertEqual(summary["failedPackages"], 1)
        self.assertEqual(len(union), 3)

    def test_nix_json_formats_are_equivalent(self):
        self.assertEqual(normalize_info({"/a": {"narSize": 10}}),
                         normalize_info([{"path": "/a", "narSize": 10}]))


if __name__ == "__main__":
    unittest.main()
