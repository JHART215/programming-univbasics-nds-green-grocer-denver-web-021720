def find_item_by_name_in_collection(name, collection)
  counter = 0
  while counter < collection.length
    if collection[counter][:item] == name
      return collection[counter]
    end
    counter += 1
  end
end

def consolidate_cart(cart:[])
  new_cart = []
  counter = 0
  while counter < cart.length
    new_cart_item = find_item_by_name_in_collection(cart[counter][:item], new_cart)
    if new_cart_item != NIL
      new_cart_item[:count] += 1
    else
      new_cart_item = {
        :item => cart[counter][:item]
        :price => cart[counter][:price]
        :clearance => cart[counter][:clearance]
        :count => 1
      }
      new_cart << new_cart_item
    end
    counter += 1
end

def apply_coupons(cart:[], coupons:[])
   app_coupon = {}
   cart.each do |item, attributes|
     coupons.each do |coupon|
       if coupon[:item] == item && attributes[:count] >= coupon[:num]
         if !app_coupon.has_key?("#{item} W/COUPON")
           app_coupon["#{item} W/COUPON"] = {
             price: coupon[:cost],
             clearance: attributes[:clearance],
             count: 0}
         end
         app_coupon["#{item} W/COUPON"][:count] += 1
         attributes[:count] -= coupon[:num]
       end
     end
   end
   cart.merge!(app_coupon)
  end

def apply_clearance(cart:[])
  app_clear = {}
  cart.each do |item_name, value|
     app_clear[item_name] = value
      if value[:clearance] == true
        value[:price] = (value[:price] * 0.8).round(2)
      end
  end
  app_clear
end


def checkout(cart: [], coupons: [])
  total = 0 
  cart = apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), 
                         coupons: coupons))
  cart.each do |item_name, value|
     total += value[:price] * value[:count]
  end

  total = (total * 0.9).round(2) if total >= 100
  total
end