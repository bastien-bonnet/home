\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lettre-france}[2014/06/01 Lettre au format français, V0.1]
\LoadClassWithOptions{article}

\RequirePackage[francais]{babel}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}

% Settings
\setlength{\parindent}{0cm}
\pagestyle{empty}

% Variables
\def\lieuRedaction#1{\def\@lieuRedaction{#1}}


% Commands
\newcommand{\expediteur}[5]{%
	#1 \hfill \@lieuRedaction, le \today

	#2
	
	#3
	
	Tél : #4
	
	#5
}

\newcommand{\destinataire}[3]{%
	\vspace{1em}
	\begin{flushright}
	\textbf{À l’attention de #1,}
	
	#2
	
	#3
	
	\end{flushright}
	\setlength{\parskip}{1em}
}

\newcommand{\objet}[1]{%
	\vspace{1em}
	\textbf{Objet :} #1
}

\newcommand{\reference}[2]{%
	\textbf{Référence #1 :} #2
}

\newcommand{\signature}[1]{%
	\vspace{1em}
	\begin{flushright}#1\end{flushright}
}

\newcommand{\piece}[1]{%
	\vfill{}
	\textbf{Pièce jointe :}  #1
}
