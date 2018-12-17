{ freq[NR] = $1 } 

END { 
  while (1) {
    for (change in freq) {
      current += freq[change]
      if (prev[current]++ > 0) { 
        print current
        exit 
      }
    }
  }
}
