##' @title  travis setup
##' @param path to the RcppExports file
##' @export
deepstate_ci_setup<-function(path){
 travis_path<-file.path(path,".travis.yml")
  if(file.exists(travis_path)){
  travis_lines <- readLines(travis_path)
  r_packages <- nc::capture_all_str(travis_path,
                                          "r_packages:",
                                          list="(?:\n  .*)*")
  
  apt_packages <- nc::capture_all_str(travis_path,
                                    "apt_packages:",
                                list="(?:\n  .*)*")
  r_check_args <- nc::capture_all_str(travis_path,"r_check_args:",list=".*")
  env <- nc::capture_all_str(travis_path,"env:",list="(?:\n  .*)*")
  if(grepl("RInside",r_packages$list))
    print("RInside present")
  else{
    travis_lines <- gsub("r_packages:","r_packages:\n  - RInside",travis_lines)
  }
  if(grepl("valgrind",apt_packages$list))
    print("valgrind present")
  else{
    travis_lines <- gsub("apt_packages:","apt_packages:\n  - valgrind",travis_lines)
  }
  if(grepl("'--as-cran --use-valgrind'",r_check_args$list)){
    print("arg valgrind present")
  }
  else{
    travis_lines <- gsub("r_check_args:","r_check_args: '--as-cran --use-valgrind'",travis_lines)
  }
  if(grepl("'VALGRIND_OPTS='--leak-check=full --track-origins=yes'",env$list)){
    print("environment for valgrind is set")
  }
  else{
    travis_lines <- gsub("env:","env:\n  -'VALGRIND_OPTS='--leak-check=full --track-origins=yes'",travis_lines)
  }
  travis_lines <- gsub("r_github_packages:","r_github_packages:\n  - akhikolla/RcppDeepState",travis_lines)
  cat(travis_lines, file=travis_path, sep="\n")
  }
 else{
   print(".travis.yml doesn't exist in your project creating a new file !!!")
   file.create(travis_path,recursive=TRUE)
   write_to_travis <- ""
   write_to_travis <-paste0(write_to_travis,"warnings_are_errors: false\nlanguage: r\nsudo: required\n\n")
   write_to_travis<-paste0(write_to_travis,"r_packages:\n  - RInside\n  - devtools\n\nafter_success:\n  ")
   write_to_travis<-paste0(write_to_travis,"- Rscript -e 'devtools::install();devtools::test()'")
   write_to_travis<-paste0(write_to_travis,"\n\nr_check_args: '--as-cran --use-valgrind'\n")
   write_to_travis<-paste0(write_to_travis,"\napt_packages:\n  - valgrind\n\n")
   write_to_travis<-paste0(write_to_travis,"env:\n  - VALGRIND_OPTS='--leak-check=full --track-origins=yes'")
   write(write_to_travis,travis_path,append=TRUE)
 }
}