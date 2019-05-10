module ApplicationHelper
  def display_price(price)
    ("<span class='price'>" + "#{number_to_currency(price)}" + "</span>").html_safe
  end

  def display_date(date)
    ("<span class='date'>" + "#{date.strftime("%B %d, %Y")} at #{date.strftime("%H:%M %p")}" + "</span>").html_safe
  end

  def cc_display(order)
    cc = order.cc_num.gsub(/\D/, '')
    last = cc.size - 1
    first = cc.size - 4
    return cc[first..last]
  end

  def shopping_cart_count(count)
    '<i class="fa fa-shopping-cart"><span class="badge badge-danger d-flex justify-content-around">'.html_safe + "#{count}" '</span></i>'.html_safe
  end

  def orderitems_total_quantity(orderitems)
    if orderitems.nil?
      return 0
    else
      return orderitems.sum {|oi| oi.quantity }
    end
  end

  def display_order(order)
    if order == 1
      return "Order"
    else
      return "Orders"
    end
  end
end
