# The Localhost Bake-Off: One Tiny Model, Ten Engines, Your Debian Box

A field reference for actually running every engine from Chapters 6 and 8, on real Debian, against the same model, so the comparison at the end is a fair fight and not vibes. Work through each section on your own machine, fill in the results table, send it back, and we'll hand out the awards.

## Ground rules

**The model, everywhere:** [TinyLlama-1.1B-Chat-v1.0](https://huggingface.co/TinyLlama/TinyLlama-1.1B-Chat-v1.0) — Apache 2.0, no HF login/license-click required anywhere, ~1.1B params so it'll load on CPU in seconds, not minutes. Same underlying weights in every section below; only the file *format* changes per engine (that asymmetry is itself half the lesson from Chapter 8).

- GGUF (llama.cpp, Ollama, LocalAI, Juno): [`TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF`](https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF), `Q4_K_M` quant.
- Raw HF safetensors (vLLM, TGI): `TinyLlama/TinyLlama-1.1B-Chat-v1.0` directly, ungated.
- JLama's own pre-quantized format: `tjake/TinyLlama-1.1B-Chat-v1.0-Jlama-Q4`.
- **The one exception:** Llama3.java and jitLLM only understand the Llama 3 family, so TinyLlama (a Llama 2 architecture) will not load in them. Both sections below use `mukel/Llama-3.2-1B-Instruct-GGUF` at `Q8_0` (~1.3 GB, also ungated at the time of writing) instead. It is a different model of a similar size class, so treat their latency and RSS numbers as *comparable in spirit*, not byte-for-byte, and say so in your write-up.

**Hardware reality check, up front:** llama.cpp, Ollama, LocalAI, JLama, Llama3.java, java-llama.cpp, and Juno are all perfectly happy on CPU at this size, and jitLLM is run on its CPU path here (`onGPU(false)`). vLLM and TGI are built GPU-first — both *can* run CPU-only, but it's the rough path for each and called out below. If you've got an NVIDIA card, all ten should behave; if not, expect vLLM and TGI to be where the friction lives, which is itself a data point for the awards.

**Prerequisites (once, shared across sections):**

```bash
sudo apt update
sudo apt install -y build-essential cmake git curl libcurl4-openssl-dev python3-venv zip unzip time

# A JDK new enough for JLama (needs 20+) and Juno — SDKMAN sidesteps whatever
# stock JDK version your Debian release happens to ship:
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 21.0.5-tem

# JBang runs single-file Java programs and fetches their Maven dependencies.
# Needed for JLama, Llama3.java, jitLLM and java-llama.cpp below:
curl -Ls https://sh.jbang.dev | bash -s - app setup
source ~/.bashrc   # picks up jbang on PATH

# Docker, for TGI (and optionally LocalAI):
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER   # log out/in once for this to take effect
```

**The standard test request** — same prompt, same cap, same temperature, used in every section's benchmark step so the numbers are comparable:

```bash
TEST_BODY='{"messages":[{"role":"user","content":"Explain what a Java interface is, in exactly two sentences."}],"max_tokens":120,"temperature":0,"model":"MODEL_NAME"}'
```

(`MODEL_NAME` gets swapped per engine below — most of these only ever have one model loaded and are lenient about the field, but a couple aren't, so each section gives you the exact value.)

Three of the engines (Llama3.java, jitLLM, java-llama.cpp) are libraries or CLIs with no HTTP endpoint, so they can't take `TEST_BODY`. They get the identical question, cap, and temperature through their own interface instead:

```bash
PROMPT="Explain what a Java interface is, in exactly two sentences."
```

**What we're capturing for the awards** — five numbers per engine, all measurable with tools already on a stock Debian box, no extra profiling software needed:

1. **Install friction** — rough command count / minutes from "nothing installed" to "server up." Subjective, note it anyway.
2. **Disk footprint** — `du -sh` on the binary/image plus the model file.
3. **Cold start** — wall-clock from launch command to the server answering a health check.
4. **Request latency** — `time curl ...` on the standard test request, the `real` line.
5. **Peak RSS** — `grep VmRSS /proc/<PID>/status` right after the test request completes.

For the three no-server engines, `/usr/bin/time -v <command>` is the stand-in: its `Elapsed (wall clock) time` is the latency (JVM start and model load included, so it is a *cold* number), and its `Maximum resident set size (kbytes)` is the peak RSS. `/usr/bin/time` reports a *peak*, whereas `VmRSS` is the value *at that moment*; if you want strictly like-for-like numbers across all ten, grep `VmHWM` (the high-water mark) instead of `VmRSS` in the server sections.

---

## 1. llama.cpp

```bash
git clone --depth=1 https://github.com/ggml-org/llama.cpp
cd llama.cpp
cmake -B build
cmake --build build --config Release -j "$(nproc)"
```

Binaries land in `build/bin/`. Newer llama.cpp pulls straight from a HF repo:quant tag, no manual download step:

```bash
./build/bin/llama-server -hf TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF:Q4_K_M --port 8080
```

```bash
time curl -s http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "${TEST_BODY/MODEL_NAME/tinyllama}" -o /tmp/llamacpp-resp.json

grep VmRSS /proc/$(pgrep -f llama-server)/status
du -sh build/bin/llama-server ~/.cache/llama.cpp 2>/dev/null
```

**Heads-up:** this is the one with no runtime dependency at all beyond libc — worth noting for the install-friction score once the build finishes, since the build step itself is the only friction there is.

## 2. Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama run hf.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF:Q4_K_M
```

That second command both pulls the model and starts serving on `:11434` (OpenAI-compatible at `/v1/chat/completions` since early 2024, no flag needed). Exit the chat REPL with `/bye`; the server keeps running in the background.

```bash
time curl -s http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "${TEST_BODY/MODEL_NAME/hf.co\/TheBloke\/TinyLlama-1.1B-Chat-v1.0-GGUF:Q4_K_M}" -o /tmp/ollama-resp.json

grep VmRSS /proc/$(pgrep -x ollama)/status
du -sh ~/.ollama/models
```

**Heads-up:** the `model` field has to be the *exact* string you pulled, including the `hf.co/...:Q4_K_M` tag — this is the one engine where that field isn't just decorative.

## 3. LocalAI

Docker is the currently-recommended path — LocalAI's own `install.sh` has an open issue around broken/misconfigured installs on some systems, so skip it for now rather than debug someone else's install script:

```bash
docker run -d --name local-ai -p 8080:8080 \
  -v ~/models:/models \
  localai/localai:latest-cpu
```

Grab the same GGUF once, reuse it here (and in Juno, below):

```bash
mkdir -p ~/models
huggingface-cli download TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF \
  --local-dir ~/models --include "*Q4_K_M*"
# if the exact filename below doesn't match what got downloaded, check
# the repo's Files tab and adjust — TheBloke's naming is consistent but verify, don't guess
docker exec local-ai local-ai models install tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf 2>/dev/null || true
```

```bash
time curl -s http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "${TEST_BODY/MODEL_NAME/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf}" -o /tmp/localai-resp.json

docker stats local-ai --no-stream --format "{{.MemUsage}}"
docker images localai/localai --format "{{.Size}}"
```

**Heads-up:** memory capture here goes through `docker stats` instead of `/proc`, since the process is in a container — worth a footnote when you write up results, it's not quite the same measurement as the bare-metal engines.

## 4. vLLM

```bash
python3 -m venv ~/vllm-env
source ~/vllm-env/bin/activate
pip install vllm   # CUDA build by default — see the CPU note below if you don't have a GPU
vllm serve TinyLlama/TinyLlama-1.1B-Chat-v1.0
```

Defaults to `:8000`.

```bash
time curl -s http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "${TEST_BODY/MODEL_NAME/TinyLlama\/TinyLlama-1.1B-Chat-v1.0}" -o /tmp/vllm-resp.json

grep VmRSS /proc/$(pgrep -f "vllm serve")/status
du -sh ~/.cache/huggingface/hub/models--TinyLlama--TinyLlama-1.1B-Chat-v1.0
```

**Heads-up, no-GPU case:** `pip install vllm` pulls the CUDA build by default. CPU-only needs building from source with `VLLM_TARGET_DEVICE=cpu` set before the install — noticeably more involved than every other engine here, which is itself worth a category in the awards. If you hit a wall, it's fine to log "DNF, CPU-only" as the result rather than burn your evening on it.

## 5. TGI

```bash
docker run -d --name tgi -p 8080:80 \
  ghcr.io/huggingface/text-generation-inference:latest \
  --model-id TinyLlama/TinyLlama-1.1B-Chat-v1.0
```

```bash
time curl -s http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "${TEST_BODY/MODEL_NAME/tgi}" -o /tmp/tgi-resp.json

docker stats tgi --no-stream --format "{{.MemUsage}}"
```

**Heads-up:** same GPU-first shape as vLLM — the image above assumes CUDA is reachable inside the container (`nvidia-container-toolkit` installed, `--gpus all` added to the run command). CPU-only TGI exists but is the least-traveled path of the ten; if it fights you, that's a legitimate result too, not a sign you did something wrong.

## 6. JLama

```bash
jbang app install --force jlama@tjake

jlama restapi tjake/TinyLlama-1.1B-Chat-v1.0-Jlama-Q4 --auto-download
```

Starts an OpenAI-compatible API *and* a chat UI at `http://localhost:8080/`.

```bash
time curl -s http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "${TEST_BODY/MODEL_NAME/tjake\/TinyLlama-1.1B-Chat-v1.0-Jlama-Q4}" -o /tmp/jlama-resp.json

grep VmRSS /proc/$(pgrep -f jlama)/status
```

**Heads-up:** this is the one running on the JDK you just installed via SDKMAN — worth watching JVM startup/warmup specifically, since that's a cost none of the C++/Rust/Python engines pay, and it's exactly the trade-off Chapter 8 gestures at without putting a number on it. Now you'll have one.

## 7. Juno

You know this one's exact invocation better than I do — the pattern from your own Chapter 8 and 17 is `<your-launch-command> --api-port 8080`. Point it at the *same* GGUF file already sitting in `~/models/` from the LocalAI step — no separate download.

```bash
time curl -s http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "${TEST_BODY/MODEL_NAME/tinyllama}" -o /tmp/juno-resp.json

grep VmRSS /proc/$(pgrep -f juno)/status
```

**Heads-up:** this is the one you get to grade with full inside knowledge — probably worth running twice, once as a typical reader would follow your docs cold, once as you'd actually run it, and noting if those two differ.

## 8. Llama3.java

The whole engine is one Java source file, run through JBang: no build, no server, no dependencies beyond JDK 21+ (the SDKMAN JDK 21 from the prerequisites is enough). It is a CLI, not an HTTP server, so latency and memory come from `/usr/bin/time -v`. It only reads Llama 3-family GGUF files, hence the different model (see ground rules).

```bash
git clone --depth=1 https://github.com/mukel/llama3.java ~/llama3.java
mkdir -p ~/models
curl -L -o ~/models/Llama-3.2-1B-Instruct-Q8_0.gguf \
  https://huggingface.co/mukel/Llama-3.2-1B-Instruct-GGUF/resolve/main/Llama-3.2-1B-Instruct-Q8_0.gguf

# First run compiles the single source file and caches it. Do this once BEFORE timing anything:
cd ~/llama3.java && jbang Llama3.java --help
```

Cold start (load the model, emit one token) and the standard request:

```bash
cd ~/llama3.java
M=~/models/Llama-3.2-1B-Instruct-Q8_0.gguf

# cold start
/usr/bin/time -v jbang Llama3.java --model "$M" --prompt "$PROMPT" \
  --max-tokens 1 --temperature 0 --stream false 2>&1 | grep -E "Elapsed|Maximum resident"

# standard request
/usr/bin/time -v jbang Llama3.java --model "$M" --prompt "$PROMPT" \
  --max-tokens 120 --temperature 0 --stream false 2>&1 | grep -E "Elapsed|Maximum resident"

du -sh ~/llama3.java ~/models/Llama-3.2-1B-Instruct-Q8_0.gguf
```

Want the interactive experience instead? `jbang Llama3.java --model "$M" --chat`.

**Heads-up:** the Vector API is still an incubator module and the engine needs JDK 21+ preview features, so if JBang complains about missing flags, run `jbang Llama3.java --help` first and read what it says; the README's plain-`java` equivalent is `java --enable-preview --source 21 --add-modules jdk.incubator.vector Llama3.java --model ...`. Because this is a one-shot process, the wall-clock time includes JVM startup, class loading, and memory-mapping the weights on *every* run: worth separating from raw generation speed when you write up the results. The README also describes a GraalVM Native Image build with the model pre-loaded (`PRELOAD_GGUF=/path/to/model.gguf make native`) for near-zero time-to-first-token; that needs a GraalVM toolchain and is out of scope here, but it is the "what would the best possible JVM number look like" run if you want an extra data point.

## 9. jitLLM

A library, not a server: the model is loaded in-process through its LangChain4j integration. jitLLM's headline feature is GPU execution through TornadoVM, but that needs the TornadoVM SDK and its `tornado` launcher with `-Duse.tornadovm=true`. To keep this a fair CPU-box comparison we run its CPU path (`onGPU(false)`, a lightweight Llama3.java-based implementation per the project's README). It reads the same Llama 3.2 1B GGUF you downloaded for section 8.

JBang fetches the dependency and, because of the `//JAVA 25` line, will download a matching JDK for this one program if your default JDK is older. (jitLLM publishes separate JDK 21 and JDK 22+ builds; the JDK 22+ one is the path of least resistance and needs no preview flags.)

```bash
mkdir -p ~/bench && cd ~/bench
cat > JitBench.java <<'EOF'
//JAVA 25
//DEPS dev.langchain4j:langchain4j-jitllm:1.21.0-beta31
//RUNTIME_OPTIONS --add-modules jdk.incubator.vector

import dev.langchain4j.model.jitllm.JitLLMChatModel;
import java.nio.file.Path;

public class JitBench {
    public static void main(String[] a) {
        long t0 = System.nanoTime();
        try (JitLLMChatModel model = JitLLMChatModel.builder()
                .modelPath(Path.of(a[0]))
                .temperature(0.0)
                .maxTokens(Integer.parseInt(a[2]))
                .onGPU(false)                       // CPU path
                .build()) {
            long t1 = System.nanoTime();
            String answer = model.chat(a[1]);
            long t2 = System.nanoTime();
            System.out.println(answer);
            System.err.printf("load: %.2fs  generate: %.2fs%n", (t1 - t0) / 1e9, (t2 - t1) / 1e9);
        }
    }
}
EOF

# First run downloads dependencies. Do this once BEFORE timing anything:
jbang JitBench.java ~/models/Llama-3.2-1B-Instruct-Q8_0.gguf "$PROMPT" 8
```

Cold start and the standard request:

```bash
M=~/models/Llama-3.2-1B-Instruct-Q8_0.gguf

# cold start: load the model + one token
/usr/bin/time -v jbang JitBench.java "$M" "$PROMPT" 1 2>&1 | grep -E "load:|Elapsed|Maximum resident"

# standard request
/usr/bin/time -v jbang JitBench.java "$M" "$PROMPT" 120 2>&1 | grep -E "load:|Elapsed|Maximum resident"

du -sh ~/.m2/repository/dev/langchain4j ~/.m2/repository/io/github/beehive-lab 2>/dev/null
```

**Heads-up:** this project moves fast. The `1.21.0-beta31` version above is the current one at the time of writing, but check the [LangChain4j jitLLM page](https://docs.langchain4j.dev/integrations/language-models/jitllm) for the current coordinates before you start, and if the builder rejects `temperature(0.0)`, use `0.1` (its default) and note the difference. If you do have an NVIDIA/OpenCL/Metal GPU and want to try the headline feature, the same page documents launching through TornadoVM with `-Duse.tornadovm=true` and `onGPU(true)`; log it as a *separate* row rather than overwriting the CPU one, because it is exactly the CPU-versus-GPU split the awards care about. The `load:` line on stderr separates one-time model loading from generation, which is useful for the JVM warm-up discussion in the JLama section.

## 10. java-llama.cpp

JNI bindings: your Java code calls the real llama.cpp through a native library that ships *inside* the Maven jar for common platforms, so there is nothing to compile on a standard Linux x86_64 box. It is a library with no HTTP endpoint (hence `/usr/bin/time -v`), and, since it wraps llama.cpp, it loads the same TinyLlama GGUF as sections 1 to 3 and 7. Reuse the file from the LocalAI step:

```bash
ls ~/models/*Q4_K_M*.gguf    # the TinyLlama GGUF downloaded in section 3
```

```bash
mkdir -p ~/bench && cd ~/bench
cat > LlamaCppBench.java <<'EOF'
//JAVA 21
//DEPS de.kherud:llama:4.1.0

import de.kherud.llama.InferenceParameters;
import de.kherud.llama.LlamaModel;
import de.kherud.llama.ModelParameters;

public class LlamaCppBench {
    public static void main(String[] a) {
        long t0 = System.nanoTime();
        ModelParameters mp = new ModelParameters().setModel(a[0]);
        try (LlamaModel model = new LlamaModel(mp)) {          // AutoCloseable: frees native memory
            long t1 = System.nanoTime();
            InferenceParameters ip = new InferenceParameters(a[1])
                    .setTemperature(0f)
                    .setNPredict(Integer.parseInt(a[2]));
            String answer = model.complete(ip);
            long t2 = System.nanoTime();
            System.out.println(answer);
            System.err.printf("load: %.2fs  generate: %.2fs%n", (t1 - t0) / 1e9, (t2 - t1) / 1e9);
        }
    }
}
EOF
```

This engine does not apply a chat template for you, so hand it TinyLlama's own turn markers (the same `<|user|>` / `<|assistant|>` format you meet in Chapter 7). Then run:

```bash
M=$(ls ~/models/*Q4_K_M*.gguf | head -1)
CHAT=$'<|user|>\nExplain what a Java interface is, in exactly two sentences.</s>\n<|assistant|>\n'

# First run downloads the jar (~ tens of MB with natives). Do this once BEFORE timing anything:
jbang LlamaCppBench.java "$M" "$CHAT" 8

# cold start: load the model + one token
/usr/bin/time -v jbang LlamaCppBench.java "$M" "$CHAT" 1 2>&1 | grep -E "load:|Elapsed|Maximum resident"

# standard request
/usr/bin/time -v jbang LlamaCppBench.java "$M" "$CHAT" 120 2>&1 | grep -E "load:|Elapsed|Maximum resident"

du -sh ~/.m2/repository/de/kherud
```

**Heads-up:** the weights live in native memory that the garbage collector cannot see, so `-Xmx` does not bound them and a heap dump will not show them: the peak RSS here is the honest number, which is exactly the "what you take on when the model lives in your JVM" trade-off from Chapter 8. The `4.1.0` version, and the `ModelParameters` / `InferenceParameters` method names above, are from the project's README at the time of writing; if your compile fails on a method name, check the current README, because the API has changed between major versions. The bundled natives are CPU builds for the common platforms; GPU support (or an unusual OS/architecture) means building llama.cpp yourself with the backend you want and pointing the JVM at it (`-Dde.kherud.llama.lib.path=/path/to/libs`), per the project's README. That mirrors the Chapter 8 note that "pure Java" and "runs anywhere" part ways the moment you ask for a GPU.

---

## Results template

Fill in, send back:

| Engine | Install friction | Disk (bin+model) | Cold start | Request latency (`real`) | Peak RSS |
|---|---|---|---|---|---|
| llama.cpp | | | | | |
| Ollama | | | | | |
| LocalAI | | | | | |
| vLLM | | | | | |
| TGI | | | | | |
| JLama | | | | | |
| Juno | | | | | |
| Llama3.java | | | | | |
| jitLLM | | | | | |
| java-llama.cpp | | | | | |

## The Awards 🏆

Once the table's filled in:

- 🥇 **Fastest to First Response** —
- 🪶 **Smallest Footprint** —
- 🛠️ **Smoothest Install** —
- 🐌 **Most Patience-Testing** —
- ☕ **Most Java-Native Soul** — (free pass to JLama, Juno, Llama3.java, or jitLLM, but let's see if the numbers agree; java-llama.cpp is Java on the outside and C++ on the inside, so it makes a good control)
- 💀 **Did Not Finish** — (if vLLM or TGI beat you on CPU-only, this is a real category, not a joke one)

Send the filled table over whenever you've been through all ten — the actual comparison is more interesting with real numbers from real hardware than anything I'd estimate for you.
