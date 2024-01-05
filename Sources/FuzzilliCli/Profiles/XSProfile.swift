// Copyright 2019-2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Fuzzilli

let xsProfile = Profile(
    getProcessArguments: { (randomizingArguments: Bool) -> [String] in
        return ["-f"]
    },

    processEnv: ["UBSAN_OPTIONS":"handle_segv=0:symbolize=1:print_stacktrace=1:silence_unsigned_overflow=1",
                 "ASAN_OPTIONS": "handle_segv=0:abort_on_error=1:symbolize=1",
                 "MSAN_OPTIONS": "handle_segv=0:abort_on_error=1:symbolize=1",
                 "MSAN_SYMBOLIZER_PATH": "/usr/bin/llvm-symbolizer"],

    codePrefix: """
                function placeholder(){}
                function main() {
                """,

    codeSuffix: """
                gc();
                }
                main();
                """,

    ecmaVersion: ECMAScriptVersion.es6,

    crashTests: ["fuzzilli('FUZZILLI_CRASH', 0)", "fuzzilli('FUZZILLI_CRASH', 1)", "fuzzilli('FUZZILLI_CRASH', 2)"],

    additionalCodeGenerators: [],

    additionalProgramTemplates: WeightedList<ProgramTemplate>([]),

    disabledCodeGenerators: [],

    additionalBuiltins: [
        "gc"                  : .function([] => .undefined),
        "print"               : .function([.string] => .undefined),
        "placeholder"         : .function([] => .undefined),
    ]
)
