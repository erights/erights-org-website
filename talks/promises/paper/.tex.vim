:sy on
:set wrapmargin=8
:set nocompatible
:command! -nargs=0 M wall | make tgc05.ps
:command! -nargs=1 B write | buffer <args> | set wrapmargin=3 | set nocompatible | set undolevels=30 | set ru
:set undolevels=500
:set ru
:map  :w!<CR>:!LANG=C aspell --lang=en_US --mode=tex check %<CR>:e! %<CR> 
:imap @v \begin{verbatim} <CR><CR>\end{verbatim}<ESC>ki
:imap @V \begin{Verbatim}[frame=single,<CR>                 numbers=left]<CR>\end{Verbatim}<CR><ESC>2ko
:imap @W \begin{Verbatim}[frame=single,<CR>                 label={\tt },<CR>                 numbers=left]<CR>[<CR>]<CR>\end{Verbatim}<CR><ESC>3ko<SPACE><SPACE><SPACE><SPACE><SPACE><SPACE><SPACE><SPACE><ESC>3k$hi
:imap @w \verb\|\|<ESC>i
:imap @se \section{}<ESC>i
:imap @su \subsection{}<ESC>i
:imap @ss \subsubsection{}<ESC>i
:imap @p \paragraph{}<ESC>i
:imap @h {\it }<ESC>i
:imap @t {\tt }<ESC>i
:imap @e {\em }<ESC>i
:imap @b {\bf }<ESC>i
:imap @i \begin{itemize} <CR>\item <CR>\end{itemize}<ESC>k<END>a
:imap @m \begin{enumerate} <CR>\item <CR>\end{enumerate}<ESC>k<END>a
:imap @j \item <ESC>ha<END>
:imap @f \footnote{}<ESC>i
:imap @r \ref{}<ESC>i
:imap @ci \cite{}<ESC>i
:imap @ch \chapter{}<ESC>i
:imap @n \index{}<ESC>i
:imap @g \fig{1}{Figures/Fig/}{}{}<ESC>5ha
