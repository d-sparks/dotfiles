" ==================
"  General settings
" ==================

filetype indent plugin on
syntax on

colorscheme monokai

set nocompatible
set nu
set visualbell
set colorcolumn=80
set nowrap
set clipboard=unnamed

" ====================
"  Custom keymappings
" ====================

noremap <Bar>  <C-W>v<C-W><Right>
noremap -      <C-W>s<C-W><Down>
noremap <C-h>  <C-W><Left>
noremap <C-j>  <C-W><Down>
noremap <C-k>  <C-W><Up>
noremap <C-l>  <C-W><Right>
noremap <C-W>f <C-W>_<C-W><Bar>
nmap <ScrollWheelUp> <nop>
nmap <S-ScrollWheelUp> <nop>
nmap <C-ScrollWheelUp> <nop>
nmap <ScrollWheelDown> <nop>
nmap <S-ScrollWheelDown> <nop>
nmap <C-ScrollWheelDown> <nop>
nmap <ScrollWheelLeft> <nop>
nmap <S-ScrollWheelLeft> <nop>
nmap <C-ScrollWheelLeft> <nop>
nmap <ScrollWheelRight> <nop>
nmap <S-ScrollWheelRight> <nop>
nmap <C-ScrollWheelRight> <nop>
imap <ScrollWheelUp> <nop>
imap <S-ScrollWheelUp> <nop>
imap <C-ScrollWheelUp> <nop>
imap <ScrollWheelDown> <nop>
imap <S-ScrollWheelDown> <nop>
imap <C-ScrollWheelDown> <nop>
imap <ScrollWheelLeft> <nop>
imap <S-ScrollWheelLeft> <nop>
imap <C-ScrollWheelLeft> <nop>
imap <ScrollWheelRight> <nop>
imap <S-ScrollWheelRight> <nop>
imap <C-ScrollWheelRight> <nop>
vmap <ScrollWheelUp> <nop>
vmap <S-ScrollWheelUp> <nop>
vmap <C-ScrollWheelUp> <nop>
vmap <ScrollWheelDown> <nop>
vmap <S-ScrollWheelDown> <nop>
vmap <C-ScrollWheelDown> <nop>
vmap <ScrollWheelLeft> <nop>
vmap <S-ScrollWheelLeft> <nop>
vmap <C-ScrollWheelLeft> <nop>
vmap <ScrollWheelRight> <nop>
vmap <S-ScrollWheelRight> <nop>
vmap <C-ScrollWheelRight> <nop>

" ============================
"  Plugins and configurations
"   - codefmt (Google)
"   - NERD commenter
"   - ctrl+p
"   - YouCompleteMe
" ============================

" VAM
fun! SetupVAM()
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand('$HOME', 1) . '/.vim/vim-addons'

  " Force your ~/.vim/after directory to be last in &rtp always:
  " let g:vim_addon_manager.rtp_list_hook = 'vam#ForceUsersAfterDirectoriesToBeLast'

  " most used options you may want to use:
  " let c.log_to_buf = 1
  " let c.auto_install = 0
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
  if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
        \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
  endif

  " This provides the VAMActivate command, you could be passing plugin names, too
  call vam#ActivateAddons([], {})
endfun
call SetupVAM() 

call vam#ActivateAddons(["vim-maktaba"], {})
call vam#ActivateAddons(["vim-glaive"], {})
call vam#ActivateAddons(["vim-codefmt"], {})
call vam#ActivateAddons(["ctrlp"], {})
" TODO: build new vim so this works
" call vam#ActivateAddons(["YouCompleteMe"], {})

set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" NERD commenter
" TODO: install it
map <C-m> <Leader>c<Space>

" ctrl+p
let g:ctrl_p_working_path_mode = 'c'

" YouCompleteMe
noremap ,g<S-d> <Space>:YcmCompleter GoToDefinition<Enter><Esc>
noremap ,g<S-i> <Space>:YcmCompleter GoToImplementation<Enter><Esc>
noremap ,g<S-h> <Space>:YcmCompleter GoToInclude<Enter><Esc>
noremap ,gd     <Space>:YcmCompleter GoToDefinition<Enter><Esc>
noremap ,gi     <Space>:YcmCompleter GoToImplementation<Enter><Esc>
noremap ,gh     <Space>:YcmCompleter GoToInclude<Enter><Esc>
noremap ,fm     :FormatCode <Tab><Enter>
