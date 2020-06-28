##' @title  travis setup
##' @param path to the RcppExports file
##' @export
deepstate_ci_setup<-function(path){
 travis_path<-file.path(path,".travis.yml")
 print(travis_path)
  if(!file.exists(travis_path)){
    print(".travis.yml doesn't exist in your project creating a new file !!!")
    file.create(travis_path,recursive=TRUE)
    write_to_travis <- ""
    write_to_travis <-paste0(write_to_travis,"warnings_are_errors: false\nlanguage: r\nsudo: required\n\n")
    write_to_travis<-paste0(write_to_travis,"r_packages:\n\t- RInside\n\t- devtools\n\nafter_success:\n\t")
    write_to_travis<-paste0(write_to_travis,"- Rscript -e 'devtools::install();devtools::test()'\n\nr_check_args: '--as-cran --use-valgrind'\n")
    write_to_travis<-paste0(write_to_travis,"\naddons:\n\tapt:\n\t\tpackages:\n\t\t\t- valgrind\n\nenv:\n\t-VALGRIND_OPTS='--leak-check=full --track-origins=yes'\n\n")
    write_to_travis<-paste0(write_to_travis,"script:\n\t- |\n\ttravis_wait 60 R CMD build .\n\ttravis_wait 60 R CMD check testproject*tar.gz")
    
    write(write_to_travis,travis_path,append=TRUE)
  }
  travis_lines <- readLines(travis_path)
  r_packages <- nc::capture_all_str(travis_path,
                                          "r_packages:",
                                          list="(?:\n\t.*)*")
  apt_packages <- nc::capture_all_str(travis_path,
                                    "apt_packages:",
                                list="(?:\n\t.*)*")
  
  if(grepl("RInside",r_packages$list))
    print("RInside present")
  else{
    travis_lines <- gsub("r_packages:","r_packages:\n\t- RInside",travis_lines)
    cat(travis_lines, file=travis_path, sep="\n")
  }
  }