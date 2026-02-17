if exists('g:loaded_deepseek_translator')
  finish
endif
let g:loaded_deepseek_translator = 1

command! DeepseekTranslateWord lua require('deepseek-translator').translate_word()
command! DeepseekTranslateSelection lua require('deepseek-translator').translate_selection()

" Default keymaps
nnoremap <silent> <Plug>(deepseek-translate-word) <cmd>lua require('deepseek-translator').translate_word()<CR>
vnoremap <silent> <Plug>(deepseek-translate-selection) <cmd>lua require('deepseek-translator').translate_selection()<CR>

" Auto-map to <leader>t if not already mapped
if !hasmapto('<Plug>(deepseek-translate-word)', 'n')
  nmap <leader>fy <Plug>(deepseek-translate-word)
endif

if !hasmapto('<Plug>(deepseek-translate-selection)', 'v')
  vmap <leader>fy <Plug>(deepseek-translate-selection)
endif
