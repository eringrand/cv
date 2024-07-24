# This script builds both the HTML and PDF versions of your CV

# If you wanted to speed up rendering for googlesheets driven CVs you could use
# this script to cache a version of the CV_Printer class with data already
# loaded and load the cached version in the .Rmd instead of re-fetching it twice
# for the HTML and PDF rendering. This exercise is left to the reader.

write_pdfs <- function(rmd_name, html_name, pdf_name, resume_only = FALSE) {
  # Knit the HTML version
  rmarkdown::render(rmd_name,
                    params = list(pdf_mode = FALSE,
                                  resume_only = resume_only),
                    output_file = html_name)

  # Knit the PDF version to temporary html location
  tmp_html_cv_loc <- fs::file_temp(ext = ".html")

  rmarkdown::render(rmd_name,
                    params = list(pdf_mode = TRUE,
                                  resume_only = resume_only),
                    output_file = tmp_html_cv_loc)

  # Convert to PDF using Pagedown
  pagedown::chrome_print(input = tmp_html_cv_loc,
                         output = pdf_name)

  rmarkdown::render(rmd_name,
                    params = list(pdf_mode = TRUE,
                                  resume_only = resume_only),
                    output_file = tmp_html_cv_loc)

  # Convert to PDF using Pagedown
  pagedown::chrome_print(input = tmp_html_cv_loc,
                         output = pdf_name)
}


write_pdfs("resume.rmd", "resume.html", "resume.pdf", resume_only = TRUE)
write_pdfs("cv.rmd", "cv.html", "cv.pdf", resume_only = FALSE)
#write_pdfs("cover_letter_headspace.rmd", "cover_letter_headspace.html", "cover_letter_headspace.pdf", resume_only = FALSE)

# library(pdftools)
#
# pdf_combine(c("cover_letter.pdf", "resume.pdf"),
#             output = "combined_letter_resume.pdf")
