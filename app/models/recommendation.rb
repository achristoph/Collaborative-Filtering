# To change this template, choose Tools | Templates
# and open the template in the editor.

class Recommendation
  # Returns a distance-based similarity score for person1 and person2
  def self.sim_distance(person1,person2)
    prefs1 = person1.preferences
    prefs2 = person2.preferences    
    items1 = person1.items
    items2 = person2.items
    # Get the list of shared_items
    si = items1.find_all{ |item1| items2.include?(item1) }    
    # if they have no ratings in common, return 0
    return 0 if si.size == 0
    # Add up the squares of all the differences
    sum_of_squares = items1.inject(0) do |sum, item1| 
      sum = sum + (prefs1.find_by_item_id(item1).score - prefs2.find_by_item_id(item1).score)**2 if items2.include?(item1)
      sum
    end
    return 1/(1+sum_of_squares)
  end
  
  def self.topMatches(person)
    people = Person.all
    scores =  people.collect { |p| self.sim_distance(person, p) unless person == p}
    scores.compact.sort.reverse[0..5]
  end
      
  # Returns the Pearson correlation coefficient for p1 and p2
  def self.sim_pearson(person1, person2)
    prefs1 = person1.preferences
    prefs2 = person2.preferences
    items1 = person1.items
    items2 = person2.items
    # Get the list of mutually rated items
    similar_items = {}
    similar_items = person1.items.find_all { |item1| not items2.include?(item1) }
    similar_items = person1.items.where("items.id IN (?)", items2)
    return 0 if similar_items.size == 0
    
    # Find the number of elements
    n = similar_items.size
    
    # Sum of all the preferences
    sum1 = similar_items.inject(0){ |sum, si_item| sum + prefs1.find_by_item_id(si_item).score }
    sum2 = similar_items.inject(0){ |sum, si_item| sum + prefs2.find_by_item_id(si_item).score }
    
    # Sum of the squares
    sum_of_square1 = similar_items.inject(0){ |sum, si_item| sum + prefs1.find_by_item_id(si_item).score**2 }
    sum_of_square2 = similar_items.inject(0){ |sum, si_item| sum + prefs2.find_by_item_id(si_item).score**2 }
    
    # Sum of the products
    sum_of_products = similar_items.inject(0){ |sum, si_item| sum + prefs1.find_by_item_id(si_item).score * prefs2.find_by_item_id(si_item).score  }
    
    # Calculate r (Pearson score)
    numerator = sum_of_products - (sum1 * sum2 / n)
    denominator = Math.sqrt( (sum_of_square1 - sum1**2/n) * (sum_of_square2 - sum2**2/n) )
    return 0 if denominator == 0
    
    r = numerator/denominator
    
  end
  
  def self.get_recommendations(person)
    totals = {}
    sum_of_sims = {}
    Person.where("id <> ?",person.id).each do |p|
      sim = sim_pearson(person,p)
      next if sim <= 0
      p.preferences.where("item_id NOT IN (?)", person.items).each do |p|
        totals[p.item.name] = totals.fetch(p.item.name,0) + p.score * sim
        sum_of_sims[p.item.name] = sum_of_sims.fetch(p.item.name,0) + sim
      end
    end
    
    rankings = totals.collect { |k,v|  v/sum_of_sims[k]}
  end
  
  
  
  
end
