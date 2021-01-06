# Coll.analysis V 3.2a
# Collostructional analysis: Computing the degree of association between words and words/constructions
# Coyright (C) 2007 Stefan Th. Gries (Latest changes in this version: 03/28/2010)
rm(list=ls()) # cleanup

coll.analysis<-function() { # FUNCTION FOR THE FAMILY OF COLLOSTRUCTIONAL ANALYSES
   cat("\nColl.analysis 3.2a was written by Stefan Th. Gries (<http://www.linguistics.ucsb.edu/faculty/stgries/>).\n")
   cat("It computes all methods belonging to the family of collostructional analysis as developed by\nAnatol Stefanowitsch and Stefan Th. Gries. Thus, it can also be used to compute general\ncollocational strengths of word pairs or distinctive collocates.\n\n")
   cat("Papers involving collostructional analysis by these authors include:\nStefanowitsch, Anatol & Stefan Th. Gries. 2003. Collostructions: Investigating the interaction\n   between words and constructions. International Journal of Corpus Linguistics 8.2:209-43.\n")
   cat("Gries, Stefan Th. & Anatol Stefanowitsch. 2004a. Extending collostructional analysis:\n   A corpus-based perspectives on 'alternations'. International Journal of Corpus Linguistics 9.1:97-129.\nGries, Stefan Th. & Anatol Stefanowitsch. 2004b. Co-varying collexemes in the into-causative.\n")
   cat("   In: Achard, Michel & Suzanne Kemmer (eds.). Language, Culture, and Mind. Stanford, CA: CSLI, p. 225-36.\nGries, Stefan Th. 2005. Syntactic priming: A corpus-based approach. Journal of Psycholinguistic Research 34.4:365-99.\nGries, Stefan Th. & Stefanie Wulff. 2005. Do foreign language learners also have constructions?\n")
   cat("   Evidence from priming, sorting, and corpora. Annual Review of Cognitive Linguistics 3:182-200.\nStefanowitsch, Anatol & Stefan Th. Gries. 2005. Co-varying collexemes. Corpus Linguistics\n   and Linguistic Theory 1.1:1-43.\nGries, Stefan Th. & Anatol Stefanowitsch. 2010. Cluster analysis and the identification of collexeme\n   classes.")
   cat("In: Newman, John & Sally Rice (eds.). Empirical and Experimental Methods in Cognitive/Functional\n   Research. Stanford, CA: CSLI, p. 73-90.\n\nFor papers that document the predictive superiority of collostructional analysis over raw frequency counts, cf:\nGries, Stefan Th., Beate Hampe, & Doris Schönefeld. 2005. Converging evidence: [...].")
   cat(" Cognitive Linguistics 16.4:635-76.\nGries, Stefan Th., Beate Hampe, & Doris Schönefeld. 2010. Converging evidence II: [...]. In: Newman, John &\n   Sally Rice (eds.). Experimental and Empirical Methods in Cognitive/Functional Research. Stanford, CA: CSLI, p. 59-72.\n\n")
   cat("You can obtain all these papers (and many more) from my website.\n\n----------------------------\nThis program is free software; you can redistribute it and/or modify it under the terms of the\nGNU General Public License as published by the Free Software Foundation; either version 2 of\nthe License, or (at your option) any later version.\n")
   cat("   Because the program is licensed free of charge, there is no warranty for the program, to the\nextent permitted by applicable law. Except when otherwise stated in writing the copyright holders\nand/or other parties provide the program 'as is' without warranty of any kind, either expressed\nor implied, including, but not limited to, the implied warranties of merchantability and fitness\nfor a particular purpose.")
   cat(" The entire risk as to the quality and performance of the program is\nwith you. Should the program prove defective, you assume the cost of all necessary servicing,\nrepair or correction.\n   In no event unless required by applicable law or agreed to in writing will any copyright holder,\nor any other party who may modify and/or redistribute the program as permitted above, be liable\nto you for damages, including any general, special, incidental or consequential damages arising")
   cat("\nout of the use or inability to use the program (including but not limited to loss of data or\ndata being rendered inaccurate or losses sustained by you or third parties or a failure of the\nprogram to operate with any other programs), even if such holder or other party has been advised\nof the possibility of such damages.\n\nAcknowledgments: I thank Gaëtanelle Gilquin and Stefanie Wulff for pointing out small bugs to me, which have been fixed in this version.\nLatest changes in this version: 03/28/2010")
   cat("\n----------------------------\n\nYou should have received this program with a collection of example files and a readme file;\nI recommend that you have a look at them before you execute this program for the first time ...\n\n"); pause()
   cat("\nIf you use the program, PLEASE QUOTE IT as follows:\nGries, Stefan Th. 2007. Coll.analysis 3.2a. A program for R for Windows 2.x.\n\n"); pause()

   which.analysis<-menu(choice=c("collocational/ collostructional strength, i.e. collexeme analysis (cf. <1*.txt> for an example)",
                                 "(multiple) distinctive collocates or distinctive collexeme analysis (cf. <2*.txt> for an example)",
                                 "co-varying collexeme analysis (cf. <3*.txt> for an example)"), title="\nWhich kind of analysis do you want to perform?")

   switch(which.analysis, collostructions(), dist.collexemes(),covar.collexemes())

} # END OF FUNCTION FOR THE FAMILY OF COLLOSTRUCTIONAL ANALYSES



collostructions<-function() { # FUNCTION FOR COLLEXEME ANALYSIS
   cat("\nC o l l o c a t i o n a l / c o l l e x e m e    a n a l y s i s   . . .\n")

   # introduction
   cat("\nThis kind of analysis computes the degree of attraction and repulsion between\none word or construction and many other words using a user-defined statistic;\nall these statistics are based on 2-by-2 tables, and attraction and repulsion\nare indicated in a separate column in the output.\n")

   # input of parameters
   cat("\nWhat is the word W / the name of the construction C you investigate (without spaces)?\n")
   construction.name<-scan(nmax=1, what="char", quiet=T)
   if (length(construction.name)==0) construction.name<-"some_W_or_C"

   cat("\nEnter the size of the corpus (in constructions or words) without digit grouping symbols!\n")
   corpus<-scan(nmax=1, quiet=T)
   while (corpus<=0) { cat("\nWith a value of 0 or smaller, no such tests can be computed - enter the correct corpus size!\n"); corpus<-scan(nmax=1, quiet=T) }

   cat("\nEnter the frequency of", construction.name, "in the corpus you investigate (without digit grouping symbols)\n")
   construction.freq<-scan(nmax=1, quiet=T)
   while (construction.freq<=0) { cat("\nWith a value of 0 or smaller, no such tests can be computed - enter the correct word/construction frequency!\n"); construction.freq<-scan(nmax=1, quiet=T) }

   which.index<-menu(choice=c("-log10 (Fisher-Yates exact, one-tailed) (= default)", "log-likelihood", "Mutual Information", "Chi-square", "log10 of odds ratio (adds 0.5 to each cell)"), title="\nWhich index of association strength do you want to compute?")

   which.sort<-menu(choice=c("alphabetically", "co-occurrence frequency", "faith", "collostruction strength"), title="\nHow do you want to sort the output?")

   cat("\nEnter the number of decimals you'd like to see in the results (and '99', when you want the default output)!\n")
   which.accuracy<-scan(nmax=1, quiet=T); cat("\n")
   while (which.accuracy<=0) { cat("\nWith a value of 0 or smaller, the output might not be very meaningful - enter the correct number of decimals!\n"); which.accuracy<-scan(nmax=1, quiet=T) }

   cat("\nTo compute the collocational strength of one word W to many other words <A, B, ..., ?>,\nyou need a text file with the following kind of table (with column names!):\n\nWord\tFreq_A-?_in_Corpus\tFreq_A-?_&_W\nA\t...\t\t\t...\nB\t...\t\t\t...\n...\t...\t\t\t...\n\nTo compute the collostructional strength of one construction C to the words <A, B, ..., ?>,\nyou need a text file with the following kind of table (with column names!):\n\nWord\tFreq_A-?_in_Corpus\tFreq_A-?_in_C\nA\t...\t\t\t...\nB\t...\t\t\t...\n...\t...\t\t\t...\n\n")
   cat("Your table must not have decimal points/separators and ideally has no spaces (for the latter, use '_' instead)!\nAlso, don't forget that R's treatment of alphanumeric characters is case-sensitive!\n\nChoose this text file with the raw data!\t"); pause()
   data<-read.table(file.choose(), header=T, fileEncoding = "UTF-8", sep="\t", quote="", comment.char=""); cases<-length(data[,1]); cat("\n")

   which.output<-menu(choice=c("text file (= default)", "terminal"), title="Where do you want the output ('text file' will append to already existing file with the same name)?")

   # computation

   words<-data[,1]; word.freq<-data[,2]; obs.freq<-data[,3]; exp.freq<-faith<-delta.p.constr.to.word<-delta.p.word.to.constr<-relation<-coll.strength<-c(rep(0, cases))

   for (i in 1:cases) {
      obs.freq.a<-obs.freq[i]
      obs.freq.b<-construction.freq-obs.freq.a
      obs.freq.c<-word.freq[i]-obs.freq.a
      obs.freq.d<-corpus-(obs.freq.a+obs.freq.b+obs.freq.c)

      exp.freq.a<-construction.freq*word.freq[i]/corpus; exp.freq[i]<-round(exp.freq.a, which.accuracy)
      exp.freq.b<-construction.freq*(corpus-word.freq[i])/corpus
      exp.freq.c<-(corpus-construction.freq)*word.freq[i]/corpus
      exp.freq.d<-(corpus-construction.freq)*(corpus-word.freq[i])/corpus

      faith[i]<-round((obs.freq.a/word.freq[i]), which.accuracy)

      delta.p.constr.to.word[i]<-round((obs.freq.a/(obs.freq.a+obs.freq.b))-(obs.freq.c/(obs.freq.c+obs.freq.d)), which.accuracy)
      delta.p.word.to.constr[i]<-round((obs.freq.a/(obs.freq.a+obs.freq.c))-(obs.freq.b/(obs.freq.b+obs.freq.d)), which.accuracy)

      coll.strength[i]<-round(switch(which.index,
         fye(obs.freq.a, exp.freq.a, construction.freq, corpus, word.freq[i]),
         llr(obs.freq.a, obs.freq.b, obs.freq.c, obs.freq.d, exp.freq.a, exp.freq.b, exp.freq.c, exp.freq.d),
         log((obs.freq.a/exp.freq.a), 2),
         (corpus*(((obs.freq.a)*((corpus-construction.freq-word.freq[i]+obs.freq.a)))-((construction.freq-obs.freq.a)*(word.freq[i]-obs.freq.a)))^2)/(construction.freq*word.freq[i]*((construction.freq-obs.freq.a)+((corpus-construction.freq-word.freq[i]+obs.freq.a)))*((word.freq[i]-obs.freq.a)+((corpus-construction.freq-word.freq[i]+obs.freq.a)))),
         log(((obs.freq.a+0.5)/(obs.freq.b+0.5))/((obs.freq.c+0.5)/(obs.freq.d+0.5)), 10)), which.accuracy)
      if (obs.freq.a>exp.freq.a) {
         relation[i]<-"attraction"
      } else if (obs.freq.a<exp.freq.a) {
         relation[i]<-"repulsion"
      } else {
         relation[i]<-"chance"
      }
   }

   output.table<-data.frame(words, word.freq, obs.freq, exp.freq, relation, faith, delta.p.constr.to.word, delta.p.word.to.constr, coll.strength)
   sort.index<-switch(which.sort, order(words), order(-obs.freq, words), order(-faith, words), order(relation, -coll.strength))
   output.table<-output.table[sort.index,]

   # hypothetical repulsion strength of unattested verbs
   corp.size<-as.integer(log(corpus, 10))
   absents.words<-absents.obs.freqs<-absents.exp.freqs<-absents.delta.p.constr.to.word<-absents.delta.p.word.to.constr<-absents.collstrengths<-c(rep(0, corp.size))
   for (i in 1:corp.size) {
      absents.words[i]<-letters[i]
      absents.obs.freqs[i]<-10^i

      obs.freq.a<-0
      obs.freq.b<-construction.freq
      obs.freq.c<-10^i
      obs.freq.d<-corpus-(construction.freq+10^i)

      exp.freq.a<-construction.freq*10^i/corpus; absents.exp.freqs[i]<-round(exp.freq.a, which.accuracy)
      exp.freq.b<-construction.freq*(corpus-10^i)/corpus
      exp.freq.c<-(corpus-construction.freq)*10^i/corpus
      exp.freq.d<-(corpus-construction.freq)*(corpus-10^i)/corpus

      absents.delta.p.constr.to.word[i]<-round((obs.freq.a/(obs.freq.a+obs.freq.b))-(obs.freq.c/(obs.freq.c+obs.freq.d)), which.accuracy)
      absents.delta.p.word.to.constr[i]<-round((obs.freq.a/(obs.freq.a+obs.freq.c))-(obs.freq.b/(obs.freq.b+obs.freq.d)), which.accuracy)

      absents.collstrengths[i]<-round(switch(which.index,
         fye(obs.freq.a, exp.freq.a, construction.freq, corpus, word.freq[i]),
         llr(obs.freq.a, obs.freq.b, obs.freq.c, obs.freq.d, exp.freq.a, exp.freq.b, exp.freq.c, exp.freq.d),
         log((obs.freq.a/exp.freq.a), 2),
         (corpus*(((obs.freq.a)*((corpus-construction.freq-word.freq[i]+obs.freq.a)))-((construction.freq-obs.freq.a)*(word.freq[i]-obs.freq.a)))^2)/(construction.freq*word.freq[i]*((construction.freq-obs.freq.a)+((corpus-construction.freq-word.freq[i]+obs.freq.a)))*((word.freq[i]-obs.freq.a)+((corpus-construction.freq-word.freq[i]+obs.freq.a)))),
         log(((obs.freq.a+0.5)/(obs.freq.b+0.5))/((obs.freq.c+0.5)/(obs.freq.d+0.5)), 10)), which.accuracy)
   }

   output.table.hyp<-data.frame(absents.words, absents.obs.freqs, absents.exp.freqs, "repulsion", absents.delta.p.constr.to.word, absents.delta.p.word.to.constr, absents.collstrengths)
   colnames(output.table.hyp)<-c("absents.words", "absents.obs.freqs", "absents.exp.freqs", "relation", "absents.delta.p.constr.to.word", "absents.delta.p.word.to.constr", "absents.collstrengths")
   cat("\a") # progress beep

   # output
   which.index<-switch(which.index, "-log10 (Fisher-Yates exact, one-tailed)", "log-likelihood", "Mutual Information", "Chi-square", "log10 of odds ratio (adds 0.5 to each cell)")
   if (which.output==1) {
      cat("\nWhich text file do you want to store the result in?\n(Note: if you choose a file that already exists, the current output will be appended to this file.)\t"); pause()
      output.file<-file.choose(); output<-file(output.file, open="at")
      cat("|---------------------------------------------------------------------|\n| This output is provided without any warranty on an as-is basis by   |\n| Stefan Th. Gries <http://www.linguistics.ucsb.edu/faculty/stgries/> |\n| Please cite the program as mentioned in <readme.txt>. Thanks a lot! |\n|---------------------------------------------------------------------|\n\n", date(), "\n\nword.freq: frequency of the word in the corpus\nobs.freq: observed frequency of the word with/in ", construction.name, file=output)
      cat("\nexp.freq: expected frequency of the word with/in ", construction.name, "\nfaith: percentage of how many instances of the word occur with/in ", construction.name, "\nrelation: relation of the word to ", construction.name, "\ndelta.p.constr.to.word: delta p: how much does the word/construction help guess the word?\ndelta.p.constr.to.word: delta p: how much does the construction help guess the word/construction?\ncoll.strength: index of collocational/collostructional strength: ", which.index, ", the higher, the stronger\n\n", sep="", file=output)
      write.table(output.table, file=output, quote=F, row.names=F, sep="\t", eol="\n")
      cat("\nIn order to determine the degree of repulsion of verbs that are not attested with/in", construction.name, ",\nthe following table gives the collocational/collostructional strength for all verb frequencies\nin orders of magnitude the corpus size allows for.\n\n\n", sep="", file=output)
      write.table(output.table.hyp, file=output, quote=F, row.names=F, sep="\t", eol="\n")
      cat("\n\nIf your collostruction strength is based on p-values, it can be interpreted as follows:\nColl.strength>3 => p<0.001; coll.strength>2 => p<0.01; coll.strength>1.30103 => p<0.05.\nI'd be happy if you provided me with feedback and acknowledged the use of Coll.analysis 3.2a.\n", file=output)
      close(output)
   } else {
      cat("|---------------------------------------------------------------------|\n| This output is provided without any warranty on an as-is basis by   |\n| Stefan Th. Gries <http://www.linguistics.ucsb.edu/faculty/stgries/> |\n| Please cite the program as mentioned in <readme.txt>. Thanks a lot! |\n|---------------------------------------------------------------------|\n\n", date(), "\n\nword.freq: frequency of the word in the corpus\nobs.freq: observed frequency of the word with/in ", construction.name)
      cat("\nexp.freq: expected frequency of the word with/in ", construction.name, "\nfaith: percentage of how many instances of the word occur with/in ", construction.name, "\nrelation: relation of the word to ", construction.name, "\ncoll.strength: index of collocational/collostructional strength: ", which.index, ", the higher, the stronger\n\n", sep="")
      print(output.table)
      cat("\nIn order to determine the degree of repulsion of words that are not attested with/in ", construction.name, ",\nthe following table gives the collocational/collostructional strength for all verb frequencies\nin orders of magnitude the corpus size allows for.\n\n", sep="")
      print(output.table.hyp)
      cat("\nIf your collostruction strength is based on p-values, it can be interpreted as follows:\nColl.strength>3 => p<0.001; coll.strength>2 => p<0.01; coll.strength>1.30103 => p<0.05.\nI'd be happy if you provided me with feedback and acknowledged the use of Coll.analysis 3.2a.\n")
   }
} # END OF FUNCTION FOR COLLOSTRUCTIONAL ANALYSIS



dist.collexemes<-function() { # FUNCTION FOR DISTINCTIVE COLLEXEME ANALYSIS

   cat("\nD i s t i n c t i v e   c o l l o c a t e / c o l l e x e m e   a n a l y s i s   . . .\n")

   # introduction and first input
   cat("\nThis kind of analysis compares 2+ words or constructions with respect to n words they co-occur with differently frequently.\nYou must first enter whether you have two distinctive categories (e.g., when you look at English ditransitive\nvs. prep. dative) or more (e.g., when you compare English active vs. be-passive vs. get-passive)?\n")
   dists<-menu(choice=c(" 2 alternatives", " 3+ alternatives"), title="How many distinctive categories do you have?")

   cat("\nEnter the number of decimals you'd like to see in the results (and '99', when you want the default output)!\n")
   which.accuracy<-scan(nmax=1, quiet=T); cat("\n")
   while (which.accuracy<=0) { cat("\nWith a value of 0 or smaller, the output might not be very meaningful - enter the correct number of decimals!\n"); which.accuracy<-scan(nmax=1, quiet=T) }

   if (dists==1) {

      # introduction
      cat("\nIn this case, distinctive collexeme analysis uses the log-transformed\np-value from the one-tailed Fisher-Yates exact test or the log-likelihood ratio\nand indicates preferences in a separate column.\n")

      # input of parameters
      which.index<-menu(choice=c("-log10 (Fisher-Yates exact, one-tailed) (= default)", "log-likelihood"), title="Which index of association strength do you want to compute?")

      which.sort<-menu(choice=c("alphabetically", "frequency with W1 / in C1", "frequency with W2 / in C2", "collostruction strength"), title="How do you want to sort the output?")

      cat("\nColl.analysis 3.2a accepts two kinds of input for such an analysis of distinctive collexemes:\nOn the one hand, you can use as input a file with a table of all tokens. That is, the first column\ncontains for each co-occurrence item the code for one of the two words/constructions W1/C1 and\nW2/C2 you want to investigate; the second column contains the word co-occurring with W1/C1 and W2/C2\nas listed in the first column.")
      cat("\n\nW/C\tColl_Word\nA\tX\nB\tY\n...\t...\n\nOn the other hand, if you have already down more work, you can also use a text file\nwith the following kind of table (with informative column names!), where the columns 2 and 3\ncontain the co-occurrence frequencies of each word listed in column 1 with/in W/C1 and W/C2.\n\nColl_Word\tFreq_CollWord_&_W/C1\tFreq_CollWord_&_W/C2\nA\t\t...\t\t\t...\nB\t\t...\t\t\t...\n...\t\t...\t\t\t...")
      cat("\n\nWhichever input format you choose, your file must not have decimal points/separators and ideally has no spaces (for the latter, use '_' instead)!\nAlso, don't forget that R's treatment of alphanumeric characters is case-sensitive!\n\n")
      input.dc<-menu(choice=c("Raw list of all tokens", "Edited list with frequencies"), title="Which input format do you want to use?")

      cat("\nChoose the text file with the input data!\n"); pause()
      data<-read.table(file.choose(), header=T, sep="\t", quote="", comment.char="")

      if (input.dc==1) {
         interim<-t(table(data))
         data<-data.frame(as.vector(rownames(interim)), as.vector(interim[,1]), as.vector(interim[,2]))
         names(data)<-c("WORD", colnames(interim))
      }

      construction1.name<-colnames(data)[2]
      construction2.name<-colnames(data)[3]

      cat("\nEnter the overall frequency of", construction1.name, "in the corpus you investigate without digit grouping symbols (probably, this is", sum(data[,2]), "i.e., the number of occurrences of this construction in your data file)!\n")
      construction1.freq<-scan(nmax=1, quiet=T)
      while (construction1.freq<=0) {
         cat("\nWith a value of 0 or smaller, no such tests can be computed - enter the correct word/construction frequency!\n"); construction1.freq<-scan(nmax=1, quiet=T)
      }
      cat("\nEnter the overall frequency of", construction2.name, "in the corpus you investigate without digit grouping symbols (probably, this is", sum(data[,3]), "i.e., the number of occurrences of this construction in your data file)!\n")
      construction2.freq<-scan(nmax=1, quiet=T)
      while (construction2.freq<=0) {
         cat("\nWith a value of 0 or smaller, no such tests can be computed - enter the correct word/construction frequency!\n"); construction2.freq<-scan(nmax=1, quiet=T)
      }

      which.output<-menu(choice=c("text file", "terminal"), title="Where do you want the output ('text file' will append to already existing file with the same name)?")

      # computation

      cases<-length(data[,1]); words<-data[,1]; obs.freq.1<-data[,2]; obs.freq.2<-data[,3]; exp.freq.1<-exp.freq.2<-pref.occur<-delta.p.constr.to.word<-delta.p.word.to.constr<-coll.strength<-c(rep(0, cases)); overlap<-0

      for (i in 1:cases) {
         obs.freq.a<-obs.freq.1[i]
         obs.freq.b<-construction1.freq-obs.freq.a
         obs.freq.c<-obs.freq.2[i]
         obs.freq.d<-construction2.freq-obs.freq.c

         exp.freq.a<-(data[i,2]+data[i,3])*construction1.freq/(construction1.freq+construction2.freq); exp.freq.1[i]<-round(exp.freq.a, which.accuracy)
         exp.freq.b<-construction1.freq-exp.freq.a
         exp.freq.c<-(data[i,2]+data[i,3])*construction2.freq/(construction1.freq+construction2.freq); exp.freq.2[i]<-round(exp.freq.c, which.accuracy)
         exp.freq.d<-construction2.freq-exp.freq.c

         coll.strength[i]<-round(switch(which.index,
            fye(obs.freq.a, exp.freq.a, construction1.freq, sum(construction1.freq, construction2.freq), sum(obs.freq.a, obs.freq.c)),
            llr(obs.freq.a, obs.freq.b, obs.freq.c, obs.freq.d, exp.freq.a, exp.freq.b, exp.freq.c, exp.freq.d),
            log(((obs.freq.a+0.5)/(obs.freq.b+0.5))/((obs.freq.c+0.5)/(obs.freq.d+0.5)), 10)), which.accuracy)

         if (obs.freq.a>exp.freq.a) {
            pref.occur[i]<-as.character(construction1.name)
         } else if (obs.freq.a<exp.freq.a) {
            pref.occur[i]<-as.character(construction2.name)
         } else {
            pref.occur[i]<-"no_preference"
         }

         delta.p.constr.to.word[i]<-round((obs.freq.a/(obs.freq.a+obs.freq.b))-(obs.freq.c/(obs.freq.c+obs.freq.d)), which.accuracy)
         delta.p.word.to.constr[i]<-round((obs.freq.a/(obs.freq.a+obs.freq.c))-(obs.freq.b/(obs.freq.b+obs.freq.d)), which.accuracy)

         overlap<-ifelse(all(obs.freq.a>0, obs.freq.c>0), overlap<-overlap+1, overlap)
      }

      output.table<-data.frame(words, obs.freq.1, obs.freq.2, exp.freq.1, exp.freq.2, pref.occur, delta.p.constr.to.word, delta.p.word.to.constr, coll.strength)
      sort.index<-switch(which.sort, order(words), order(-obs.freq.1, words),order(-obs.freq.2, words), order(pref.occur, -coll.strength))
      output.table<-as.data.frame(output.table[sort.index,])
      cat("\a") # progress beep

      # output
      which.index<-switch(which.index, "-log10(Fisher-Yates exact, one-tailed)", "log-likelihood")

      cat("\n")
      if (which.output==1) {
         cat("\nWhich text file do you want to store the result in?\n(Note: if you choose a file that already exists, the current output will be appended to this file.)\t"); pause()
         output.file<-file.choose(); output<-file(output.file, open="at")
         cat("|---------------------------------------------------------------------|\n| This output is provided without any warranty on an as-is basis by   |\n| Stefan Th. Gries <http://www.linguistics.ucsb.edu/faculty/stgries/> |\n| Please cite the program as mentioned in <readme.txt>. Thanks a lot! |\n|---------------------------------------------------------------------|\n\n", date(), file=output)
         cat("\n\nDistinctive collocate/collexeme analysis for: ", as.character(construction1.name), " vs. ", as.character(construction2.name), "\n\nobs.freq.1: observed frequency of the word A-? in/with ", as.character(construction1.name), "\nobs.freq.2: observed frequency of the word A-? in/with ", as.character(construction2.name), "\nexp.freq.1: expected frequency of the word A-? in/with ", sep="", file=output)
         cat(as.character(construction1.name), "\nexp.freq.2: expected frequency of the word A-? in/with ", as.character(construction2.name), "\npref.occur: the word/construction to which the word A-? is attracted\ndelta.p.constr.to.word: delta p: how much does the word/construction help guess the word?\ndelta.p.word.to.constr: delta p: how much does the construction help guess the word/construction?\ncoll.strength: index of distinctive collostructional strength:", which.index, ", the higher, the more distinctive\n\n", sep="", file=output)
         write.table(output.table, file=output, quote=F, row.names=F, sep="\t", eol="\n")
         cat("\nIf your collostruction strength is based on p-values, it can be interpreted as follows:\nColl.strength>3 => p<0.001; coll.strength>2 => p<0.01; coll.strength>1.30103 => p<0.05.\nOut of the ", cases, " investigated, ", overlap," collocates/collexemes are shared by both words/constructions; i.e. ", (overlap/cases*100), "%\n\n\nI'd be happy if you provided me with feedback and acknowledged the use of Coll.analysis 3.2a.\n", sep="", file=output)
         close(output)
      } else {
         cat("|---------------------------------------------------------------------|\n| This output is provided without any warranty on an as-is basis by   |\n| Stefan Th. Gries <http://www.linguistics.ucsb.edu/faculty/stgries/> |\n| Please cite the program as mentioned in <readme.txt>. Thanks a lot! |\n|---------------------------------------------------------------------|\n\n", date(), "\n\nDistinctive collocate/collexeme analysis for: ")
         cat(as.character(construction1.name), " vs. ", as.character(construction2.name), "\n\nobs.freq.1: observed frequency of the word A-? in/with ", as.character(construction1.name), "\nobs.freq.2: observed frequency of the word A-? in/with ", as.character(construction2.name), "\nexp.freq.1: expected frequency of the word A-? in/with ", as.character(construction1.name), "\nexp.freq.2: expected frequency of the word A-? in/with ")
         cat(as.character(construction2.name), "\npref.occur: the word/construction to which the word A-? is attracted\ncoll.strength: index of distinctive collostructional strength: ", which.index, ", the higher, the more distinctive\n\n", sep="")
         options(width=7500); print(output.table)
         cat("\nIf your collostruction strength is based on p-values, it can be interpreted as follows:\nColl.strength>3 => p<0.001; coll.strength>2 => p<0.01; coll.strength>1.30103 => p<0.05.\nOut of the ", cases, " investigated, ", overlap," collocates/collexemes are shared by both words/constructions; i.e. ", (overlap/cases*100), "%\n\n\nI'd be happy if you provided me with feedback and acknowledged the use of Coll.analysis 3.2a.\n", sep="")
      }

   } else {

      # introduction
      cat("\nIn this case of multiple distinctive collexeme analysis, a more detailed introduction is necessary.\nIn regular collexeme analysis as well as distinctive collexeme analysis, we have always used the\none-tailed Fisher Yates exact test to compute the association strength between elements. As the name indicates,\nthis is an exact tests which is applied to 2-by-2 table and based on the hypergeometric distribution,")
      cat("\ni.e., on sampling without replacement. If you want to perform a distinctive collexeme analysis with more\nthan two alternatives, e.g. English active vs. be-passive vs. get-passive, however,\n\nVOICE\t\tVERB\nactive\t\tthink\nbe-passive\ttell\nget-passive\tkill\n...\t\t...\n\nthen the Fisher-Yates exact test cannot be used anymore. ")
      cat("The equivalent test for more than two alternatives\nis the so-called multinomial test, an exact test with sampling without replacement for 2+ alternatives.\nHowever, given the present purposes this test has two weaknesses:\n(i) it is computationally so expensive that sample sizes of several thousand items already exceed the capabilities of\nstate-of-the-art desktop computers in fall 2004, and ")
      cat("(ii) the multinomial test only gives you a single\np-value and, thus, doesn't tell you where some deviation actually comes from: is an\noverall large deviation due to the low frequency for, say, _think_ in actives, or, say, the high frequency of,\nsay, _kill_ in get-passives? That is, even if the test was possible computationally,\nit would not yet answer the interesting questions.\n   ")
      cat("Thus, this script uses an approximation to the multinomial test, namely the one-tailed exact binomial test.\nThis test is still an exact test, i.e., it is not sensitive to low frequencies. To use the above example,\nthe present implementation of the exact binomial test computes one p-value for each word in with\neach other word / in each construction (as in configural frequency analysis) and ")
      cat("log-transforms it such that\nhighly positive and highly negative values indicate a large degree of attraction and repulsion respectively\nwhile 0 indicates random co-occurrence.\n   Then, to make the results more accessible, the script also outputs columns called SumAbsDev and LargestDev.\nAgain, using the above example, the former tells you for each verb the sum of all ")
      cat("absolute log-transformed p-values, i.e.,\nhow strongly each verb's observed frequencies across all voices differ from the expected ones.\nThe latter tell you for each verb the single voice with the largest deviations from the expected frequencies.\n")

      # input of parameters
      cat("\nFor such a multiple distinctive collexeme analysis, Coll.analysis 3.2a expects as input\na file with a table of all tokens. That is, the first column contains for\neach co-occurrence item the code for one of the X words/constructions W/C\nyou want to investigate; the second column contains the word co-occurring with W/C")
      cat("\nas listed in the first column.\n\nW/C\tColl_Word\nA\tX\nB\tY\nC\tZ\n...\t...\n\nYour file ideally has no spaces (use '_' instead) and don't forget that R's treatment of alphanumeric characters\nis case-sensitive! The computation of this analysis can require several minutes or even more time ...\n\nChoose the text file with the input data!\t"); pause()
      mdca.data<-read.table(file.choose(), header=T, sep="\t", quote="", comment.char="")
      names(mdca.data)<-c("W_C", "Coll_Word")

      which.sort<-menu(choice=c("alphabetically (W_C)", "sum of absolute deviations per W_C", "W_Cs' largest deviation"), title="\nHow do you want to sort the output?")

      # determine column frequencies
      tab.mca.data<-table(mdca.data$Coll_Word, mdca.data$W_C) # generate table for multiple dca
      colfreq<-table(mdca.data$W_C)
      verb<-rownames(tab.mca.data); constr<-colnames(tab.mca.data)
      n.verb<-length(verb); n.constr<-length(constr)

      result.table<-data.frame(matrix(nrow=n.verb, ncol=(n.constr*3)+3))
      colnames(result.table)<-c("Coll_Word", as.character(constr), paste("exp", as.character(constr), sep="_"), paste("pbin", as.character(constr), sep="_"), "SumAbsDev", "LargestDev")
      result.table[,1]<-rownames(tab.mca.data)
      result.table[,2:(n.constr+1)]<-tab.mca.data[,1:n.constr]


      for (f in 1:n.verb) {

         cur.obs<-tab.mca.data[f,]
         cur.exp<-sum(cur.obs)*(colfreq/sum(colfreq))
         result.table[f,(n.constr+2):(n.constr+n.constr+1)]<-round(cur.exp, which.accuracy)

         counter<-0
         for (g in (n.constr*2+2):(length(result.table)-2)) {
            counter<-counter+1
            if (cur.obs[counter]>=cur.exp[counter]) {
               result.table[f,g]<-round(-log(sum(dbinom(cur.obs[counter]:sum(cur.obs), sum(cur.obs), (cur.exp[counter]/sum(cur.obs)))), 10), which.accuracy)
            } else {
               result.table[f,g]<-round(log(sum(dbinom(0:cur.obs[counter], sum(cur.obs), (cur.exp[counter]/sum(cur.obs)))), 10), which.accuracy)
            }
         }

         result.table[f,length(result.table)-1]<-round(sum(abs(result.table[f,(length(names(result.table))-n.constr-1):(length(names(result.table))-2)])), which.accuracy)
         largest.value<-round(max(abs(result.table[f,(length(result.table)-n.constr-1):(length(result.table)-2)])), which.accuracy)
         largest.word<-as.character(constr[which(abs(result.table[f,(length(result.table)-n.constr-1):(length(result.table)-2)])==largest.value)])
         if (length(largest.word)>1) { largest.word<-paste(largest.word, collapse="_&_") }
         result.table[f,length(result.table)]<-largest.word
      }

      attach(result.table)
      cat("\a") # progress beep

      # output

      which.output<-menu(choice=c("text file", "terminal"), title="Where do you want the output ('text file' will append to already existing file with the same name)?")

      sort.index<-switch(which.sort, order(Coll_Word), order(-SumAbsDev, Coll_Word), order(LargestDev, -SumAbsDev))
      result.table<-as.data.frame(result.table[sort.index,])
      if (which.output==1) {
         cat("\nWhich text file do you want to store the result in?\n(Note: if you choose a file that already exists, the current output will be appended to this file.)\t"); pause()
         output.file<-file.choose(); output<-file(output.file, open="at")
            cat("|---------------------------------------------------------------------|\n| This output is provided without any warranty on an as-is basis by   |\n| Stefan Th. Gries <http://www.linguistics.ucsb.edu/faculty/stgries/> |\n| Please cite the program as mentioned in <readme.txt>. Thanks a lot! |\n|---------------------------------------------------------------------|\n\n", date(), file=output)
            cat("\n\nMultiple distinctive collocate/collexeme analysis for:", paste(as.character(constr), collapse=" "), "\n\nColl_Word: collocate of the words/constructions to be contrasted\nThe next ", paste(as.character(constr), collapse=" "), " columns are the words/constructions to be contrasted and their observed co-occurrence frequencies\nThe next ", paste(as.character(constr), collapse=" "), file=output)
            cat(" columns are the words/constructions to be contrasted and their expected co-occurrence frequencies\nThe next ", paste(as.character(constr), collapse=" "), " columns are the log-transformed p-values of the words/constructions to be contrasted (+ = attraction, - = repulsion)\nSumAbsDev: the sum of the absolute values of the preceding ", n.constr, " columns: the larger, the stronger the deviation", file=output)
            cat("\nLargestDev: the word/construction where the strongest deviation from observed to expected is found\n\n", sep="", file=output)
            write.table(result.table, file=output, quote=F, row.names=F, sep="\t", eol="\n")
            cat("\n\nSorting according to the 'pbin' columns will yield the most relevant outcomes for each word/construction.\npbin_*>3 => p<0.001; pbin_*>2 => p<0.01; pbin_*>1.30103 => p<0.05.\nI'd be happy if you provided me with feedback and acknowledged the use of Coll.analysis 3.2a.\n", file=output)
            close(output)
      } else {
         cat("\n|---------------------------------------------------------------------|\n| This output is provided without any warranty on an as-is basis by   |\n| Stefan Th. Gries <http://www.linguistics.ucsb.edu/faculty/stgries/> |\n| Please cite the program as mentioned in <readme.txt>. Thanks a lot! |\n|---------------------------------------------------------------------|\n\n", date())
         cat("\n\nMultiple distinctive collocate/collexeme analysis for: ", paste(as.character(constr), collapse=" "), "\n\nColl_Word: collocate of the words/constructions to be contrasted\nThe next", as.character(constr), "columns are the words/constructions to be contrasted and their observed co-occurrence frequencies\nThe next ", paste(as.character(constr), collapse=" "))
         cat(" columns are the words/constructions to be contrasted and their expected co-co-occurrence frequencies\nThe next ", paste(as.character(constr), collapse=" "), " columns are the log-transformed p-values of the words/constructions to be contrasted (+ = attraction, - = repulsion)\nSumAbsDev: the sum of the absolute values of the preceding ", n.constr)
         cat(" columns: the larger, the stronger the deviation\nLargestDev: the word/construction where the strongest deviation from observed to expected is found\n\n")
         options(width=7500); print(result.table)
         cat("\npbin_*>3 => p<0.001; pbin_*>2 => p<0.01; pbin_*>1.30103 => p<0.05.\nI'd be happy if you provided me with feedback and acknowledged the use of Coll.analysis 3.2a.\n")
      }

   }
} # END OF FUNCTION FOR DISTINCTIVE COLLEXEME ANALYSIS



covar.collexemes<-function() { # FUNCTION FOR CO-VARYING COLLEXEME ANALYSIS
   cat("\nC o v a r y i n g   c o l l e x e m e   a n a l y s i s   . . .\n")

   # introduction
   cat("\n\nThis kind of analysis investigated dependencies within two slots of a single construction.\nThis script so far only implements the so-called item-based analysis since comparative studies\n have shown that the system-based correction may require many days computational time with only")
   cat("\nminor differences in the results (cf. Stefanowitsch and Gries 2005). However, somewhere down the road I may find \ntime to work on an implementation of this technique so that arbitrarily many additional variables\n(e.g. register, corpora etc.) can be included.\n")

   # input of parameters
   cat("\nColl.analysis 3.2a requires as input for the item-based co-varying collexeme analysis:\na file with a table of all token instances of the construction C with\nthe two words W1 and W2 occurring in the slots of each instance of C.\n")
   cat("That is, you need the following kind of input file (with column names!)),\nwhere the number of rows corresponds to the number of construction tokens you have.\n\nWord_Slot1\tWord_Slot2\nA\t\tX\nB\t\tX\n...\t...\n\n")
   cat("Your file must not have decimal points/separators and ideally has no spaces (for the latter, use '_' instead)!\nAlso, don't forget that R's treatment of alphanumeric characters is case-sensitive!\n\n")

   cat("\nWhat is the name of the construction C you investigate (without spaces)?\t")
   construction.name<-scan(nmax=1, what="character", quiet=T)
   if (length(construction.name)==0) construction.name<-"some_C"

   which.combos<-menu(choice=c("all possible combinations (can be memory-intensive)", "only attested combinations (not memory-intensive at all)"), title="\nWhich combinations do you want to include?")
   which.index<-menu(choice=c("-log10 (Fisher-Yates exact, one-tailed) (= default)", "log-likelihood", "log10 of odds ratio (adds 0.5 to each cell)"), title="\nWhich index of association strength do you want to compute?")
   which.sort<-menu(choice=c("alphabetically (W1)", "alphabetically (W2)", "frequency (W1)", "frequency (w2)", "collostruction strength"), title="How do you want to sort the output?")

   cat("\nEnter the number of decimals you'd like to see in the results (and '99', when you want the default output)!\t")
   which.accuracy<-scan(nmax=1, quiet=T); cat("\n")
   while (which.accuracy<=0) { cat("\nWith a value of 0 or smaller, the output might not be very meaningful - enter the correct number of decimals!\n"); which.accuracy<-scan(nmax=1, quiet=T) }

   cat("\nChoose the text file with the raw data!\t"); pause()
   data<-read.table(file.choose(), header=T, sep="\t", colClasses=c("character", "character"), quote="", comment.char="")

   types.in.1<-sort(unique(data[,1])); ntypes.in.1<-length(types.in.1)
   types.in.2<-sort(unique(data[,2])); ntypes.in.2<-length(types.in.2)
   construction.freq<-length(data[,1])

   x<-table(data)
   W1_C<-rep(types.in.1, each=ntypes.in.2)
   W2_C<-rep(types.in.2, ntypes.in.1)
   Freq_W1_C<-rep(as.vector(rowSums(x)), each=ntypes.in.2)
   Freq_W2_C<-rep(as.vector(colSums(x)), ntypes.in.1)
   W1_W2_in_C<-as.vector(t(x))
   data<-data.frame(W1_C, W2_C, Freq_W1_C, Freq_W2_C, W1_W2_in_C)

   if (which.combos==2) {
      data<-subset(data, data[,5]!=0)
   }

   # computation
   cases<-length(data[,1])
   words1<-data[,1]; words2<-data[,2]; freq.w1<-data[,3]; freq.w2<-data[,4]; obs.w1_2.in_c<-data[,5]
   exp.w1_2.in_c<-c(rep(0, cases)); relation<-c(rep(0, cases)); delta.p.constr.to.word<-delta.p.word.to.constr<-coll.strength<-c(rep(0, cases))

   for (i in 1:cases) {

      obs.freq.a<-obs.w1_2.in_c[i]
      obs.freq.b<-freq.w1[i]-obs.freq.a
      obs.freq.c<-freq.w2[i]-obs.freq.a
      obs.freq.d<-construction.freq-(obs.freq.a+obs.freq.b+obs.freq.c)

      exp.freq.a<-freq.w1[i]*freq.w2[i]/construction.freq; exp.w1_2.in_c[i]<-round(exp.freq.a, which.accuracy)
      exp.freq.b<-freq.w1[i]-exp.freq.a
      exp.freq.c<-freq.w2[i]-exp.freq.a
      exp.freq.d<-construction.freq-(exp.freq.a+exp.freq.b+exp.freq.c)

      coll.strength[i]<-round(switch(which.index,
         fye(obs.freq.a, exp.freq.a, freq.w1[i], construction.freq, freq.w2[i]),
         llr(obs.freq.a, obs.freq.b, obs.freq.c, obs.freq.d, exp.freq.a, exp.freq.b, exp.freq.c, exp.freq.d),
         log(((obs.freq.a+0.5)/(obs.freq.b+0.5))/((obs.freq.c+0.5)/(obs.freq.d+0.5)), 10)), which.accuracy)

      if (obs.freq.a>exp.freq.a) {
         relation[i]<-"attraction"
      } else if (obs.freq.a<exp.freq.a) {
         relation[i]<-"repulsion"
      } else {
         relation[i]<-"chance"
      }

      delta.p.constr.to.word[i]<-round((obs.freq.a/(obs.freq.a+obs.freq.b))-(obs.freq.c/(obs.freq.c+obs.freq.d)), which.accuracy)
      delta.p.word.to.constr[i]<-round((obs.freq.a/(obs.freq.a+obs.freq.c))-(obs.freq.b/(obs.freq.b+obs.freq.d)), which.accuracy)
   }


   which.index<-switch(which.index, "-log10 (Fisher-Yates exact, one-tailed)", "log-likelihood", "log10 of odds ratio (adds 0.5 to each cell)")
   exp.w1_2.in_c<-round(exp.w1_2.in_c, 2); output.table<-data.frame(words1, words2, freq.w1, freq.w2, obs.w1_2.in_c, exp.w1_2.in_c, relation, delta.p.constr.to.word, delta.p.word.to.constr, coll.strength)
   cat("\a") # progress beep

   which.output<-menu(choice=c("text file", "terminal"), title="\nWhere do you want the output ('text file' will append to already existing file with the same name)?")

   # output
   sort.index<-switch(which.sort, order(words1, relation, -coll.strength), order(words2, relation, -coll.strength), order(-freq.w1, relation, -coll.strength), order(-freq.w2, relation, -coll.strength), order(relation, -coll.strength))
   output.table<-output.table[sort.index,]

   if (which.output==1) {
      cat("\nWhich text file do you want to store the result in?\n(Note: if you choose a file that already exists, the current output will be appended to this file.)\t"); pause()
      output.file<-file.choose(); output<-file(output.file, open="at")
      cat("|---------------------------------------------------------------------|\n| This output is provided without any warranty on an as-is basis by   |\n| Stefan Th. Gries <http://www.linguistics.ucsb.edu/faculty/stgries/> |\n| Please cite the program as mentioned in <readme.txt>. Thanks a lot! |\n|---------------------------------------------------------------------|\n\n", date(), file=output)
      cat("\n\nCo-varying collexeme analysis for: ", construction.name, "\n\nwords1: words in the 1st slot of ", construction.name, "\nwords2: words in the 2nd slot of ", construction.name, "\nfreq.w1: frequency of word1 in ", construction.name, "\nfreq.w2: frequency of word2 in ", construction.name, "\nobs.w1_2.in_c: observed frequency of both words in both slots in ", construction.name, file=output)
      cat("\nexp.w1_2.in_c: expected frequency of both words in both slots in ", construction.name, "\nrelation: relation between observed and expected frequency\ncoll.strength: index of co-varying collexeme strength: ", which.index, ", the higher, the stronger\n\n", sep="", file=output)
      write.table(output.table, file=output, quote=F, row.names=F, sep="\t", eol="\n")
      cat("\nIf your collostruction strength is based on p-values, it can be interpreted as follows:\nColl.strength>3 => p<0.001; coll.strength>2 => p<0.01; coll.strength>1.30103 => p<0.05.\nI'd be happy if you provided me with feedback and acknowledged the use of Coll.analysis 3.2a.\n", file=output)
      close(output)
   } else {
      cat("|---------------------------------------------------------------------|\n| This output is provided without any warranty on an as-is basis by   |\n| Stefan Th. Gries <http://www.linguistics.ucsb.edu/faculty/stgries/> |\n| Please cite the program as mentioned in <readme.txt>. Thanks a lot! |\n|---------------------------------------------------------------------|\n\n", date())
      cat("\n\nCo-varying collexeme analysis for: ", construction.name, "\n\nwords1: words in the 1st slot of ", construction.name, "\nwords2: words in the 2nd slot of ", construction.name, "\nfreq.w1: frequency of word1 in ", construction.name, "\nfreq.w2: frequency of word2 in ", construction.name, "\nobs.w1_2.in_c: observed frequency of both words in both slots in ", construction.name)
      cat("\nexp.w1_2.in_c: expected frequency of both words in both slots in ", construction.name, "\nrelation: relation between observed and expected frequency\ncoll.strength: index of co-varying collexeme strength: ", which.index, ", the higher, the stronger\n\n", sep="")
      options(width=7500); print(output.table)
      cat("\nIf your collostruction strength is based on p-values, it can be interpreted as follows:\nColl.strength>3 => p<0.001; coll.strength>2 => p<0.01; coll.strength>1.30103 => p<0.05.\nI'd be happy if you provided me with feedback and acknowledged the use of Coll.analysis 3.2a.\n")
   }

} # END OF FUNCTION FOR CO-VARYING COLLEXEME ANALYSIS

pause<-function() {
   cat("Press <Enter> to continue ... ")
   readline()
   invisible()
}

fye<-function(oa, ea, cf, cs, wf) {
   if(oa>ea) {
      return(-log(sum(dhyper(oa:cf, cf, (cs-cf), wf)), 10))
   } else {
      return(-log(sum(dhyper(0:oa, cf, (cs-cf), wf)), 10))
   }
}

llr<-function(oa, ob, oc, od, ea, eb, ec, ed) {
   s1<-ifelse(log((oa/ea), base=exp(1))*oa=="NaN", 0, log((oa/ea), base=exp(1))*oa)
   s2<-ifelse(log((ob/eb), base=exp(1))*ob=="NaN", 0, log((ob/eb), base=exp(1))*ob)
   s3<-ifelse(log((oc/ec), base=exp(1))*oc=="NaN", 0, log((oc/ec), base=exp(1))*oc)
   s4<-ifelse(log((od/ed), base=exp(1))*od=="NaN", 0, log((od/ed), base=exp(1))*od)
   return(2*sum(s1, s2, s3, s4))
}

coll.analysis()
