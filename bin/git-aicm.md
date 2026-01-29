# git-aicm: AI-Powered Commit Messages

Automatically generate commit messages for your staged changes using GitHub Copilot.

## Usage

```bash
# Stage your changes
git add <files>

# Generate and commit with AI
git aicm
# or
g aicm
```

## How It Works

1. Analyzes your staged changes (`git diff --cached`)
2. Sends the diff to GitHub Copilot CLI with a customizable prompt
3. Generates a commit message following conventional commit format
4. Prompts you to:
   - **Y** (default): Commit with the generated message
   - **n**: Cancel the commit
   - **e**: Edit the message before committing

## Customizing the Prompt

To customize how commit messages are generated, edit the `COMMIT_PROMPT` variable at the top of `~/.dotfiles/bin/git-aicm`.

The default prompt generates messages in conventional commit format:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `style:` for formatting changes
- `refactor:` for code refactoring
- `test:` for test updates
- `chore:` for maintenance tasks

### Example Customizations

**More detailed messages:**
```bash
COMMIT_PROMPT="Generate detailed commit messages with:
- A subject line under 50 characters
- A blank line
- A detailed body explaining WHY the change was made
- List any breaking changes"
```

**Different format (Angular style):**
```bash
COMMIT_PROMPT="Use Angular commit format:
<type>(<scope>): <subject>

Where scope is the affected component or module."
```

**Emoji commits:**
```bash
COMMIT_PROMPT="Generate commit messages with appropriate emoji prefixes:
✨ :sparkles: for new features
🐛 :bug: for bug fixes
📝 :memo: for documentation
♻️ :recycle: for refactoring"
```

## Requirements

- GitHub Copilot CLI must be installed:
  ```bash
  npm install -g @github/copilot
  ```

## Tips

- The quality of the generated message depends on:
  - How clear your code changes are
  - How well-staged your changes are (smaller, focused commits work better)
  - Your prompt customization

- For best results:
  - Stage related changes together
  - Avoid mixing multiple unrelated changes in one commit
  - Use descriptive variable and function names in your code

## Troubleshooting

**"No staged changes to commit"**
- Run `git add` to stage your changes first

**"GitHub Copilot CLI not found"**
- Install it: `npm install -g @github/copilot`
- Make sure it's in your PATH

**Generated message doesn't match your style**
- Edit the `COMMIT_PROMPT` in the script
- Try being more specific about what you want
- Include examples in your prompt

**Message generation fails**
- Check your internet connection
- Verify Copilot CLI is working: `copilot --version`
- Try running with a smaller diff (stage fewer changes)