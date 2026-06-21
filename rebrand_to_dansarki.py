import os
import re

def replace_in_file(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        try:
            with open(file_path, 'r', encoding='latin-1') as f:
                content = f.read()
        except:
            print(f"Skipping binary file: {file_path}")
            return

    original_content = content

    # 1. MURG TEXTILE ENTERPRISES -> Dansarki General Enterprise
    content = re.sub(r'MURG TEXTILE ENTERPRISES', 'Dansarki General Enterprise', content, flags=re.IGNORECASE)
    
    # 2. Murg -> Dansarki (case sensitive for proper nouns)
    content = re.sub(r'Murg', 'Dansarki', content)
    
    # 3. MURG -> DANSARKI (all caps)
    content = re.sub(r'MURG', 'DANSARKI', content)
    
    # 4. murglogo.jpg -> dansarkilogo.jpg
    content = re.sub(r'murglogo\.jpg', 'dansarkilogo.jpg', content, flags=re.IGNORECASE)

    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated: {file_path}")

def walk_and_replace(root_dir):
    exclude_dirs = {'.git', 'assets', 'bootstrap', 'plugins', 'cgi-bin'}
    exclude_files = {'replace_all.py', 'debug.txt', 'rebrand_to_dansarki.py'}
    
    for root, dirs, files in os.walk(root_dir):
        # Modify dirs in place to skip excluded directories
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        
        for file in files:
            if file in exclude_files:
                continue
            if file.endswith(('.php', '.html', '.js', '.css', '.sql', '.py', '.txt')):
                file_path = os.path.join(root, file)
                replace_in_file(file_path)

if __name__ == "__main__":
    target_dir = r'c:\xampp\htdocs\dansarki'
    walk_and_replace(target_dir)
