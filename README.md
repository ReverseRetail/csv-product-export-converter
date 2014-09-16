# CSV Product Export Converter

CSV Product Export Converter is a small ruby script that helps to transform a product export from Plenty Markets 5.0 into the new Plenty Markets 5.1 product export.

The following transformations are performed:

 * color is stripped from the title and written to a seperate column
 * size is stripped from the title and written to a seperate column
 * all html tags are removed from the description