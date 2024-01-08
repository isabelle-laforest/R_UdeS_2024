# install.packages('pacman')
library(pacman)
p_load(tidyverse, phyloseq, vegan, DESeq2, microbiome)

### Barplot data
psMoss <- readRDS("data/psMossMAGs.RDS")

melt <- psMoss %>% psmelt %>% 
  select(OTU, Sample, Abundance, Compartment, Microsite, Host, Family)

topTaxa <- melt %>%  
  group_by(Family) %>% # melt the table and group by tax level
  summarise(Abundance = sum(Abundance)) %>% # find most overall abundant taxa
  arrange(desc(Abundance)) %>%  # Species them 
  mutate(aggTaxo = as.factor(case_when( # aggTaxo will become the plot legend
    row_number()<=10 ~ Family, #+++ We'll need to manually order the species!
    row_number()>10~'Others'))) %>%  # +1 to include the Others section!
  select(-Abundance)

subset <- left_join(melt, topTaxa, by = 'Family') %>% 
  group_by(Sample, aggTaxo, Host, Compartment) %>%
  summarise(seq_count = sum(Abundance)) %>%
  ungroup() %>% 
  filter(aggTaxo != 'Others') %>% 
  dplyr::rename(Family = aggTaxo) %>% 
  arrange(Family)

write_tsv(subset, 'Data/sequence_counts.tsv')

### Ordination data
# VST and distance calculation
# dist.mx <- psMoss %>% 
#   phyloseq_to_deseq2(~Compartment) %>% # DESeq2 object
#   estimateSizeFactors(., geoMeans = apply(
#     counts(.), 1, function(x) exp(sum(log(x[x>0]))/length(x)))) %>% 
#   DESeq2::varianceStabilizingTransformation(blind=T) %>% # VST
#   SummarizedExperiment::assay(.) %>% t %>% 
#   { .[. < 0] <- 0; . } %>% 
#   vegdist

distclr.mx <- psMoss %>% microbiome::transform('clr') %>% 
  otu_table %>% t %>% # on veut une composante par échantillon...
  vegan::vegdist('euclidean')

PCoA <- capscale(distclr.mx~1, distance = "euclidean")

# dataframe with variables of interest
pcoa.df <- data.frame(PCOA1 = PCoA %>% scores %$% sites %>% .[,1], 
                      PCOA2 = PCoA %>% scores %$% sites %>% .[,2]) %>%
  cbind(psMoss %>% 
          sample_data %>% 
          data.frame# %>% 
#          select(Host, Compartment)
) %>% 
  rownames_to_column('Sample')

write_tsv(pcoa.df, 'Data/pcoa.tsv')





