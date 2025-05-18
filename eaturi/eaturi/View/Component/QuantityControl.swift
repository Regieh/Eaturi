import SwiftUI
struct QuantityControl: View {
    @Binding var quantity: Int
    var onIncrement: () -> Void
    var onDecrement: () -> Void
    var buttonSize: CGFloat = 32
    var iconSize: CGFloat = 12
    var textWidth: CGFloat = 30
    var fontSize: CGFloat = 16
    var textSpacing: CGFloat = 4
    
    var body: some View {
        HStack(spacing: textSpacing){
            // Minus button
            Button(action: {
                if quantity > 1 {
                    onDecrement()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(quantity > 1 ? Color("colorOren") : Color("colorOrenDisable"))
                        .frame(width: buttonSize, height: buttonSize)

                    Image(systemName: "minus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundColor(.white)
                }
            }
            .disabled(quantity <= 1)

            
            // Quantity text
            Text("\(quantity)")
                .font(.system(size: fontSize))  // Use the dynamic fontSize parameter
                .fontWeight(.semibold)  // Added to match headline style
                .frame(width: textWidth, alignment: .center)
            
            // Plus button
            Button(action: onIncrement) {
                ZStack {
                    Circle()
                        .fill(Color("colorOren"))
                        .frame(width: buttonSize, height: buttonSize)
                    
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(6)
        .cornerRadius(buttonSize / 2 + 6)
    }
}
