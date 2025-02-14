# scrap web pages to get clear links
library(rvest)
library(tidyverse)
library(stringr)

n <- "2112"
url.books.index <- "http://www.dominiopublico.gov.br/pesquisa/ResultadoPesquisaObraForm.do?first=2112&skip=0&ds_titulo=&co_autor=&no_autor=&co_categoria=2&pagina=2&select_action=Submit&co_midia=2&co_obra=&co_idioma=1&colunaOrdenar=null&ordem=null"
# url.book.detail <- "http://www.dominiopublico.gov.br/pesquisa/DetalheObraForm.do?select_action=&co_obra=81912"
# url.book.download <- "http://www.dominiopublico.gov.br/pesquisa/DetalheObraDownload.do?select_action=&co_midia=2&co_obra=81912"
url.book.download <- "http://www.dominiopublico.gov.br/pesquisa/DetalheObraDownload.do?select_action=&co_midia=2&co_obra="

html.doc <- read_html(url.books.index)

html.doc %>%
  html_node("#res") %>%
  html_table(fill=T, trim=T, header=F) -> books.table

books.table[8:nrow(books.table), 3:4] %>%
  setNames(c("title","author")) %>% #,"source","format","size","access")) %>%
  filter( !is.na(title) , title!="" , title!=" ") %>% 
  distinct() -> books.attribs

html.doc %>%
  html_nodes("#res tbody tr td a") %>%
  html_attr("href") -> links

html.doc %>%
  html_nodes("#res tbody tr td a") %>%
  html_text(trim=T) -> titles

books.attribs %>% 
  inner_join(tibble(title=titles, link=links)) %>%
  distinct() %>%
  mutate(book.id = str_match(link,".+co_obra=(.+)")[,2]) %>%
  mutate(download = paste0(url.book.download,book.id)) %>%
  arrange(title, author) -> books

saveRDS(books,"./ele_ela_analise/data/book_links.rds")
View(head(books,100))