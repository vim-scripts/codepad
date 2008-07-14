" Vim global plugin that provides access to the codepad.org pastebin.
" Requires +python support.
"
" Add this to your ~/.vim/plugin/ directory. Then you can use
"
" :CPPaste
"     to send the current buffer to codepad.org and open your pasted code
"     in your webbrowser.
"
" :CPRun
"     to send the current buffer to codepad.org, execute it on their server,
"     and open both the pasted source and the program output in your browser.
"
" The correct filetype is automatically detected from the 'filetype' variable.
"
" Version:      1.1
" Last Change:  14 jul 2008
" Maintainer:   Nicolas Weber <nicolasweber at gmx.de>

command! CPPaste python codepadPaste()
command! CPRun python codepadRun()

python << EOF
def codepadLang(vimLang):
  filetypeMap = {
    'c':'C',
    'cpp':'C++',
    'd':'D',
    'haskell':'Haskell',
    'lua':'Lua',
    'ocaml':'Ocaml',
    'php':'PHP',
    'perl':'Perl',
    'python':'Python',
    'ruby':'Ruby',
    'scheme':'Scheme',
    'tcl':'Tcl'
  }
  return filetypeMap.get(vimLang, 'Plain Text')

def codepadGet(run):
  import urllib
  import vim

  url = 'http://codepad.org'
  data = {
    'code':'\n'.join(vim.current.buffer),
    'lang':codepadLang(vim.eval('&filetype')),
    'submit':'Submit'
  }
  if run:
    data['run'] = True

  response = urllib.urlopen(url, urllib.urlencode(data))
  return response.geturl()

def codepadPaste():
  url = codepadGet(run=False)
  import webbrowser
  webbrowser.open(url)

def codepadRun():
  url = codepadGet(run=True)
  import webbrowser
  webbrowser.open(url)
EOF
