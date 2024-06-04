export PATH=$PATH:/usr/local/go/bin

function update_ollama_models() {
    echo "Updating Ollama client..."
    curl -fsSL https://ollama.com/install.sh | sh

    # Check if ollama command is available
    if ! type ollama > /dev/null 2>&1; then
        echo "Ollama command could not be found. Please check the installation."
        return 1
    fi

    # Check if Ollama is running
    ollama_proc=$(ps aux | grep '[o]llama serve')
    if [[ -z "$ollama_proc" ]]; then
        echo "Ollama is not running. Starting Ollama serve..."
        ollama serve &
    else
        echo "Ollama serve is already running."
    fi

    echo "Fetching list of Ollama models..."
    jobs=() # Array for job management

    # Processing each line after the first from the output of `ollama list`
    ollama list | tail -n +2 | while read -r line; do
        model_name=$(echo "$line" | awk '{print $1}')
        if [[ -n "$model_name" ]]; then
            echo "Attempting to update model: $model_name"
            ollama pull "$model_name" &
            jobs+=("$!") # Add background job PID to the array
            echo "Started update for model: $model_name"
        else
            echo "No model name extracted from line: $line"
        fi
    done

    # Waiting for all background jobs to finish
    for job in "${jobs[@]}"; do
        wait "$job"
    done

    # Output the list of models with selected fields
    ollama list | tail -n +2 | awk -F"\t" '{printf $1 "\t" $3 "\t" $4 "\t" $5 RS}'

    echo "Ollama models update complete."
}

alias cat=batcat

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

eval "$(zoxide init zsh)"

