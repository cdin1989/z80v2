# Awk script to generate features.h from a CSV file
#
#  Usage: awk -f proc.awk features.csv > features.h
BEGIN {
   FS=","
   headers[0] = ""
   printf("#ifndef __FEATURE_H__\n");
   printf("#define __FEATURE_H__\n");
   printf("\n// This file is autogenerated, do not edit\n");
}
END {
   printf("#endif\n");
   printf("\n#endif\n");
}
{
   if ( FNR == 1 ) {
      for ( i = 7 ;i < NF; i++ ) {
          headers[i] = $i;
      }
   } else {
      printf("\n");
      if ( FNR == 2 ) {
         printf("#if defined(%s)",$3);
      } else {
         printf("#elif defined(%s)",$3);
      }
      if ( $4 != "" ) {
           printf("  && defined(%s)",$4);
      }
      printf("\n");
      for ( i = 7; i < NF; i++ ) {
         if ( $i == "0" && headers[i] ~ /HAVE/ ) {
             printf("// #define %s %s\n",headers[i],$i);
         } else {
             printf("#define %s %s\n",headers[i],$i);
         }
      }
   }



}