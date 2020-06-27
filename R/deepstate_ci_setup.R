

deepstate_ci_setup<-function(path){
 travis_path<-file.path(path,".travis.yml")
 print(travis_path)
  if(!file.exists(travis_path)){
    print(".travis.yml doesn't exist in your project creating a new file !!!")
    file.create(travis_path,recursive=TRUE)
    write_to_travis <- ""
    write_to_travis <-paste0(write_to_travis,"warnings_are_errors: false\nlanguage: r\nsudo: required\n")
    write_to_travis<-paste0(write_to_travis,"r_packages:\n\t- RInside\n\t- devtools\nafter_success:\n\t")
    write_to_travis<-paste0(write_to_travis,"- Rscript -e 'devtools::install();devtools::test()'\nr_check_args: '--as-cran --use-valgrind'")
    write_to_travis<-paste0(write_to_travis,"\naddons:\napt:\n packages:\n\t- valgrind\nenv:\n\t-VALGRIND_OPTS='--leak-check=full --track-origins=yes'")
    write_to_travis<-paste0(write_to_travis,"script:\n\t- |\n\ttravis_wait 60 R CMD build .\n\ttravis_wait 60 R CMD check testproject*tar.gz")
    
    write(write_to_travis,travis_path,append=TRUE)
  }
}