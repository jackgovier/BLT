#' read_blt Function
#'
#' Function to parse and process OpenSTV / OpaVote .blt files into a format with 1 ballot per line and the candidates encoded as factors.
#' @param df Desired dataframe name
#' @param filepath Filepath of blt file, including filename.blt
#' @param weight Optional parameter to return ballot weight. Default = F
#' @export
#' @examples
#' read_blt("C:/Users/User1/Documents/leader.blt")

read_blt <- function(filepath, weight = F) {
  #Import file as TSV
  b <- suppressMessages(suppressWarnings(readr::read_tsv(paste0(filepath))))
  colnames(b) <- "a"
  #Only keep lines beginning with 1 and ending with 0
  c <- dplyr::filter(b, stringr::str_detect(b$a,"^1.*[0$]"))

  #Isolate candidate names from line 2 after last ballot line
  names <- data.frame(stringr::str_split(b[max(which(stringr::str_detect(b$a,"^1.*[0$]")))+2,], "\""))
  names[] <- lapply(names, as.character)
  names <- data.frame(names[seq(1, nrow(names)-1,2),])
  names[] <- lapply(names, as.character)
  colnames(names) <- "a"
  #Match with encoding and add No Further Preferences for end of ballot
  names$b <- 1:nrow(names)
  names[nrow(names),"a"] <- "RON"
  names[nrow(names)+1,] <- c("No Further Preferences",0)

  #Create column names for preferences numbers
  coln <- paste0("pref",0:nrow(names))
  coln[1] <- "weight"
  df1 <- suppressWarnings(tidyr::separate(data = c, col = a, into = coln , sep = " "))

  #Create factor with correct levels and labels
  df2 <- df1
  df2[] <- lapply(df2, factor,
                  levels = names$b,
                  labels = names$a)

  #Determine whether to show 'Weight' in 1st column
  if(weight == T){
    df3 <- df2
    df3[,1] <- df1[,1]
  } else {
    df3 <- df2[2:ncol(df2)]
  }

  return(df3)

}

