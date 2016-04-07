#include <Rcpp.h>
#include <stdio.h>
#include <stdlib.h>
#ifdef _WIN32
  #include <io.h>
#else
  #include <unistd.h>
#endif

using namespace Rcpp;

//' An \code{writeOGR} shim to capture stdout
//'
//' @param obj the \code{Spatial} object to use
//' @param obj_size pls pass in \code{object.size(obj)}
//' @param layer spatial layer to use
//' @param writeOGR pls pass in \code{writeOGR} (no quotes)
//' @param layer_options pls pass in layer options
//' @return character vector of GeoJSON if all goes well
//' @examples \dontrun{
//' capturedWriteOGR(cities[1:10,],
//'                  object.size(cities[1:10,]),
//'                  "cities",
//'                  writeOGR))
//' }
// [[Rcpp::export]]
CharacterVector capturedWriteOGR(SEXP obj,
                                 int obj_size,
                                 SEXP layer,
                                 Function writeOGR,
                                 CharacterVector layer_options) {
  
  // we don't know how big the output is going to be.
  // this is the main problem with this approach.
  // there is no error checking yet
  // i have no idea if this works on Windows
  // this was a hack on a commuter train ;-)
  
  // this could cause us to run out of memory
  // we need checking for sizes, mem avail and errors
  
  // allocate a buffer to hold the output geojson
  // and initialize it so we's sure to have a null term'd string
  int MAX_LEN = obj_size * 10 ;
  char buffer[MAX_LEN+1];
  memset(buffer, 0, sizeof (char) * (MAX_LEN+1));
  
  // now we're going to mess with pipes. the way the VSI stuff
  // mangles stdout in gdal means that we can't use nice C++
  // redirects and have to resort to file descriptor hacking
  
  int out_pipe[2];
  int saved_stdout;
  
  saved_stdout = dup(STDOUT_FILENO);
  
  // ok, there's some error checking if we couldn't even
  // get the hack started
  #ifdef _WIN32
    if (_pipe(out_pipe, MAX_LEN, 0) != 0 ) { return(NA_STRING); }
  #else
    if (pipe(out_pipe) != 0 ) { return(NA_STRING); }
  #endif
  
  dup2(out_pipe[1], STDOUT_FILENO);
  close(out_pipe[1]);
  
  // we've setup the capture, so let writeOGR do it's thing
  // we are calling R from C since the rgdal folks have not
  // exposed anything we can use AFAI can tell
  
  writeOGR(obj, "/vsistdout/", layer, "GeoJSON", layer_options = layer_options);
  
  // ok, we let it do it's thing, now make sure we've
  // cleatned up after it
  
  fflush(stdout);
  
  // now, get that mess into somet hign we can use
  
  read(out_pipe[0], buffer, MAX_LEN);
  
  // restore order to the universe
  
  dup2(saved_stdout, STDOUT_FILENO);
  
  // say a little prayer
  
  return(wrap(buffer));
  
}
