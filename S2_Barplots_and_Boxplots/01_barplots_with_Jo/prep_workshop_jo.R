# install.packages('pacman')
library(pacman)
p_load(tidyverse, phyloseq)

psMoss <- readRDS("data/psMossMAGs.RDS")

melt <- psMoss %>% psmelt %>% 
  select(OTU, Sample, Abundance, Compartment, Microsite, Host, Phylum)

topTaxa <- melt %>%  
  group_by(Phylum) %>% # melt the table and group by tax level
  summarise(Abundance = sum(Abundance)) %>% # find most overall abundant taxa
  arrange(desc(Abundance)) %>%  # Species them 
  mutate(aggTaxo = as.factor(case_when( # aggTaxo will become the plot legend
    row_number()<=8 ~ Phylum, #+++ We'll need to manually order the species!
    row_number()>8~'Others'))) %>%  # +1 to include the Others section!
  select(-Abundance)

subset <- left_join(melt, topTaxa, by = 'Phylum') %>% 
  aggregate(Abundance~Sample+aggTaxo+Host+Compartment, # Abundance is aggregated...
            data=., FUN = sum) %>% 
  dplyr::rename(Phylum = aggTaxo) %>% 
  dplyr::rename(Seq_count = Abundance)

write_tsv(subset, 'S2_Barplots_and_Boxplots/01_barplots_with_Jo/sequence_counts.tsv')

