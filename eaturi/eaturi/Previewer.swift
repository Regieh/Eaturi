import SwiftUI
import SwiftData

struct Previewer {
    let container: ModelContainer

    @MainActor
    init() throws {
        let schema = Schema([FoodModel.self, HistoryRecord.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: config)

        // Seed sample data for previews
        let context = container.mainContext
        let previewData = [
            FoodModel(

                name: "Ayam Teriyaki", image: "ayam_teriyaki",

                price: 25000, calories: 350, protein: 30, carbs: 25, fiber: 2, fat: 15,

                isPopular: true, categories: ["Chicken"],

                availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"],

                foodDescription: "Ayam panggang saus teriyaki"

            ),

            FoodModel(

                name: "Ayam Bistik", image: "ayam_bistik",

                price: 27000, calories: 380, protein: 32, carbs: 20, fiber: 3, fat: 18,

                isPopular: true, categories: ["Chicken"],

                availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"],

                foodDescription: "Ayam bistik saus jamur"

            ),

            FoodModel(

                name: "Ayam Asam Manis", image: "ayam_asam_manis",

                price: 23000, calories: 320, protein: 28, carbs: 30, fiber: 2, fat: 12,

                isPopular: true, categories: ["Chicken"],

                availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"],
                
                foodDescription: "Ayam saus asam manis"

            ),

            FoodModel(

                name: "Ayam Lada Hitam/Fillet", image: "ayam_lada",

                price: 28000, calories: 300, protein: 35, carbs: 15, fiber: 2, fat: 14,

                isPopular: true, categories: ["Chicken"],

                availableDays: ["Senin", "Rabu", "Jumat"],

                foodDescription: "Ayam fillet lada hitam"

            ),

            FoodModel(

                name: "Ayam Bakar", image: "ayam_bakar",

                price: 24000, calories: 380, protein: 34, carbs: 18, fiber: 3, fat: 20,

                isPopular: true, categories: ["Chicken"],

                availableDays: ["Senin", "Rabu", "Jumat"],

                foodDescription: "Ayam bakar bumbu kecap"

            ),

            FoodModel(

                name: "Ayam Goreng Serundeng", image: "ayam_serundeng",

                price: 22000, calories: 400, protein: 28, carbs: 22, fiber: 2, fat: 22,

                isPopular: true, categories: ["Chicken"],

                availableDays: ["Senin", "Rabu", "Jumat"],

                foodDescription: "Ayam goreng dengan serundeng"

            ),


            // MARK: - Ikan (8 items)

            FoodModel(

                name: "Ikan Cakalang Suwir", image: "cakalang_suwir",

                price: 20000, calories: 250, protein: 25, carbs: 10, fiber: 2, fat: 10,

                isPopular: false, categories: ["Fish"],

                availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"],

                foodDescription: "Ikan cakalang suwir pedas"

            ),

            FoodModel(

                name: "Ikan Dori Asam Manis", image: "dori_asam",

                price: 28000, calories: 300, protein: 28, carbs: 25, fiber: 1, fat: 12,

                isPopular: true, categories: ["Fish"],

                availableDays: ["Senin", "Rabu", "Jumat"],

                foodDescription: "Ikan dori saus asam manis"

            ),

            FoodModel(

                name: "Ikan Sarden Rica", image: "sarden_rica",

                price: 18000, calories: 280, protein: 20, carbs: 15, fiber: 2, fat: 15,

                isPopular: false, categories: ["Fish"],

                availableDays: ["Selasa", "Kamis"],

                foodDescription: "Sarden pedas khas Manado"

            ),

            FoodModel(

                name: "Ikan Tongkol Balado", image: "tongkol_balado",

                price: 17000, calories: 270, protein: 22, carbs: 12, fiber: 2, fat: 12,

                isPopular: true, categories: ["Fish"],

                availableDays: ["Senin", "Rabu", "Jumat"],

                foodDescription: "Ikan tongkol sambal balado"

            ),

            FoodModel(

                name: "Cumi Cabe Hijau", image: "cumi_cabe",

                price: 30000, calories: 250, protein: 28, carbs: 10, fiber: 1, fat: 10,

                isPopular: true, categories: ["Fish"],

                availableDays: ["Senin", "Selasa", "Rabu", "Kamis"],

                foodDescription: "Cumi tumis cabe hijau"

            ),

            FoodModel(

                name: "Kentang Balado", image: "kentang_balado",

                price: 12000, calories: 200, protein: 4, carbs: 30, fiber: 3, fat: 8,

                isPopular: false, categories: ["Others"],

                availableDays: ["Senin", "Rabu", "Jumat"],

                foodDescription: "Kentang goreng sambal balado"

            ),

            FoodModel(

                name: "Otak-Otak Singapore Rica", image: "otak_rica",

                price: 15000, calories: 180, protein: 15, carbs: 8, fiber: 1, fat: 8,

                isPopular: true, categories: ["Fish"],

                availableDays: ["Selasa", "Kamis"],

                foodDescription: "Otak-otak pedas ala Singapura"

            ),

            FoodModel(

                name: "Sosis Oseng Bawang Cabe Rawit", image: "sosis_oseng",

                price: 15000, calories: 250, protein: 10, carbs: 15, fiber: 1, fat: 15,

                isPopular: true, categories: ["Others"],

                availableDays: ["Selasa", "Kamis"],

                foodDescription: "Sosis tumis bawang cabe rawit"

            ),


            // MARK: - Egg (7 items)

            FoodModel(

                name: "Telur Dadar Tipis", image: "telur_dadar",

                price: 8000, calories: 150, protein: 10, carbs: 2, fiber: 0, fat: 10,

                isPopular: false, categories: ["Egg"],

                availableDays: ["Senin", "Rabu", "Jumat"],

                foodDescription: "Telur dadar tipis gurih"

            ),

            FoodModel(

                name: "Telur Ceplok Balado", image: "ceplok_balado",

                price: 10000, calories: 180, protein: 12, carbs: 3, fiber: 1, fat: 12,

                isPopular: true, categories: ["Egg"],

                availableDays: ["Selasa", "Kamis"],

                foodDescription: "Telur ceplok sambal balado"

            ),

            FoodModel(

                name: "Telur Ceplok Ponti Cabe Rawit", image: "ceplok_ponti",

                price: 12000, calories: 200, protein: 13, carbs: 5, fiber: 1, fat: 14,

                isPopular: true, categories: ["Egg"],

                availableDays: ["Senin", "Rabu", "Jumat"],

                foodDescription: "Telur ceplok sambal ponti"

            ),

            FoodModel(

                name: "Telur Bulat Balado", image: "telur_bulat",

                price: 10000, calories: 170, protein: 11, carbs: 4, fiber: 1, fat: 11,

                isPopular: true, categories: ["Egg"],

                availableDays: ["Selasa", "Kamis"],

                foodDescription: "Telur rebus sambal balado"

            ),

            FoodModel(

                name: "Telur Puyuh Balado", image: "telur_puyuh",

                price: 12000, calories: 180, protein: 10, carbs: 5, fiber: 1, fat: 8,

                isPopular: true, categories: ["Egg"],

                availableDays: ["Senin", "Rabu", "Jumat"],

                foodDescription: "Telur puyuh sambal balado"

            ),

            FoodModel(

                name: "Telur Masak Semur", image: "telur_semur",

                price: 13000, calories: 220, protein: 14, carbs: 8, fiber: 1, fat: 12,

                isPopular: false, categories: ["Egg"],

                availableDays: ["Senin", "Rabu", "Jumat"],

                foodDescription: "Telur rebus kuah semur"

            ),

            FoodModel(

                name: "Tahu Masak Semur", image: "tahu_semur",

                price: 11000, calories: 150, protein: 9, carbs: 6, fiber: 1, fat: 8,

                isPopular: false, categories: ["Others"],

                availableDays: ["Senin", "Rabu", "Jumat"],

                foodDescription: "Tahu kuah semur manis"

            ),


            // MARK: - Veggies (Continue removing 'id: UUID()' for all items)

             FoodModel(

                 name: "Sayur Sawi Putih", image: "sawi_putih",

                 price: 8000, calories: 70, protein: 2, carbs: 8, fiber: 3, fat: 1,

                 isPopular: false, categories: ["Veggies"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Tumis sawi putih"

             ),

             FoodModel(

                 name: "Sayur Toge", image: "toge",

                 price: 7000, calories: 60, protein: 3, carbs: 5, fiber: 2, fat: 1,

                 isPopular: false, categories: ["Veggies"],

                 availableDays: ["Selasa", "Kamis"],

                 foodDescription: "Tumis toge wortel"

             ),

            FoodModel(

                 name: "Sayur Pok Coy", image: "pok_coy",

                 price: 9000, calories: 65, protein: 2, carbs: 6, fiber: 2, fat: 1,

                 isPopular: false, categories: ["Veggies"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Tumis pok coy saus tiram"

             ),

             FoodModel(

                 name: "Sayur Krecek", image: "sayur_krecek",

                 price: 10000, calories: 120, protein: 5, carbs: 10, fiber: 2, fat: 3,

                 isPopular: false, categories: ["Veggies"],

                 availableDays: ["Selasa", "Kamis"],

                 foodDescription: "Sayur krecek khas Jogja"

             ),

             FoodModel(

                 name: "Sayur Pare Ikan Teri", image: "pare_teri",

                 price: 9000, calories: 90, protein: 4, carbs: 8, fiber: 3, fat: 2,

                 isPopular: false, categories: ["Veggies"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Pare tumis ikan teri"

             ),

             FoodModel(

                 name: "Sayur Nangka", image: "sayur_nangka",

                 price: 10000, calories: 110, protein: 3, carbs: 12, fiber: 4, fat: 1,

                 isPopular: false, categories: ["Veggies"],

                 availableDays: ["Selasa", "Kamis"],

                 foodDescription: "Gudeg nangka muda"

             ),

            FoodModel(

                 name: "Sayur Labu", image: "sayur_labu",

                 price: 9000, calories: 100, protein: 1, carbs: 12, fiber: 3, fat: 1,

                 isPopular: false, categories: ["Veggies"],

                 availableDays: ["Selasa", "Kamis"],

                 foodDescription: "Labu siam tumis"

            ),

             FoodModel(

                 name: "Cap Cay Kuah", image: "capcay",

                 price: 18000, calories: 220, protein: 12, carbs: 25, fiber: 4, fat: 10,

                 isPopular: false, categories: ["Veggies"],

                 availableDays: ["Senin", "Kamis"],

                 foodDescription: "Cap cay mix sayuran dengan kuah"

             ),

             FoodModel(

                 name: "Tumis Kacang Panjang", image: "kacang_panjang",

                 price: 9000, calories: 80, protein: 3, carbs: 8, fiber: 3, fat: 2,

                 isPopular: false, categories: ["Veggies"],

                 availableDays: ["Selasa", "Kamis"],

                 foodDescription: "Tumis kacang panjang bawang putih"

             ),
            
            // MARK: - Fried

             FoodModel(

                 name: "Bakwan Jagung", image: "bakwan_jagung",

                 price: 5000, calories: 150, protein: 3, carbs: 20, fiber: 2, fat: 8,

                 isPopular: true, categories: ["Fried"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Bakwan jagung renyah"

             ),

             FoodModel(

                 name: "Martabak Telor", image: "martabak_telor",

                 price: 12000, calories: 300, protein: 12, carbs: 25, fiber: 1, fat: 18,

                 isPopular: true, categories: ["Fried"],

                 availableDays: ["Selasa", "Kamis"],

                 foodDescription: "Martabak telur isi daging"

             ),

            FoodModel(

                 name: "Bakwan Sayur", image: "bakwan_sayur",

                 price: 5000, calories: 130, protein: 2, carbs: 18, fiber: 2, fat: 7,

                 isPopular: true, categories: ["Fried"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Bakwan campur sayuran"

            ),

            FoodModel(

                 name: "Tahu Crispy", image: "tahu_crispy",

                 price: 8000, calories: 120, protein: 8, carbs: 10, fiber: 1, fat: 6,

                 isPopular: true, categories: ["Fried"],

                 availableDays: ["Selasa", "Kamis"],

                 foodDescription: "Tahu goreng tepung krispi"

             ),

            FoodModel(

                name: "Kerupuk Udang", image: "kerupuk",

                 price: 5000, calories: 100, protein: 2, carbs: 15, fiber: 0, fat: 5,

                 isPopular: true, categories: ["Fried"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Kerupuk udang renyah"

            ),



             // MARK: - Rice

             FoodModel(

                 name: "Nasi Putih 1 Porsi", image: "nasi_putih",

                 price: 10000, calories: 200, protein: 4, carbs: 45, fiber: 1, fat: 1,

                 isPopular: true, categories: ["Rice"],

                 availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],

                 foodDescription: "Nasi putih pulen"

             ),

             FoodModel(

                 name: "Nasi Putih 1/2 Porsi", image: "nasi_putih_half",

                 price: 6000, calories: 100, protein: 2, carbs: 22, fiber: 0, fat: 0,

                 isPopular: true, categories: ["Rice"],

                 availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],

                 foodDescription: "Nasi putih 1/2 porsi"

             ),

             FoodModel(

                 name: "Nasi Merah 1 Porsi", image: "nasi_merah",

                 price: 12000, calories: 180, protein: 5, carbs: 40, fiber: 3, fat: 1,

                 isPopular: true, categories: ["Rice"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Nasi merah organik"

             ),

             FoodModel(

                 name: "Nasi Merah 1/2 Porsi", image: "nasi_merah_half",

                 price: 7000, calories: 90, protein: 2, carbs: 20, fiber: 1, fat: 0,

                 isPopular: true, categories: ["Rice"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Nasi merah 1/2 porsi"

             ),


             // MARK: - Sambal

             FoodModel(

                 name: "Sambal Merah", image: "sambal_merah",

                 price: 3000, calories: 50, protein: 1, carbs: 5, fiber: 1, fat: 3,

                 isPopular: true, categories: ["Sambal"],

                 availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],

                 foodDescription: "Sambal merah pedas"

             ),

             FoodModel(

                 name: "Sambal Dabu-dabu", image: "sambal_dabu",

                 price: 4000, calories: 45, protein: 1, carbs: 4, fiber: 1, fat: 2,

                 isPopular: true, categories: ["Sambal"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Sambal khas Manado"

             ),

             FoodModel(

                 name: "Sambal Hijau", image: "sambal_hijau",

                 price: 4000, calories: 55, protein: 1, carbs: 6, fiber: 1, fat: 3,

                 isPopular: true, categories: ["Sambal"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Sambal hijau khas Padang"

             ),


             // MARK: - Others (including Mie, Daging)

             FoodModel(

                 name: "Mie Goreng Telor", image: "mie_telor",

                 price: 18000, calories: 350, protein: 12, carbs: 45, fiber: 2, fat: 15,

                 isPopular: true, categories: ["Others"],

                 availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],

                 foodDescription: "Mie goreng dengan telur"

             ),

             FoodModel(

                 name: "Orek Tempe Balado", image: "tempe_balado",

                 price: 10000, calories: 200, protein: 12, carbs: 15, fiber: 3, fat: 8,

                 isPopular: false, categories: ["Others"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Tempe orek sambal balado"

             ),

             FoodModel(

                 name: "Sapi Lada Hitam", image: "sapi_lada",

                 price: 35000, calories: 420, protein: 38, carbs: 25, fiber: 2, fat: 25,

                 isPopular: true, categories: ["Beef"],

                 availableDays: ["Selasa", "Rabu", "Kamis", "Jumat"],

                 foodDescription: "Daging sapi lada hitam"

             ),

            FoodModel(

                name: "Mie Goreng Special", image: "mie_special",

                price: 20000, calories: 380, protein: 15, carbs: 50, fiber: 3, fat: 18,

                isPopular: true, categories: ["Others"],

                availableDays: ["Senin", "Rabu", "Jumat"],

                foodDescription: "Mie goreng dengan tambahan seafood"

            ),

             FoodModel(

                 name: "Sop Buntut", image: "sop_buntut",

                 price: 35000, calories: 280, protein: 25, carbs: 15, fiber: 2, fat: 12,

                 isPopular: false, categories: ["Beef"],

                 availableDays: ["Jumat"],

                 foodDescription: "Sop buntut dengan kuah kaldu sapi"

             ),

             FoodModel(

                 name: "Krengsengan Kambing", image: "krengsengan",

                 price: 40000, calories: 450, protein: 40, carbs: 20, fiber: 2, fat: 28,

                 isPopular: true, categories: ["Beef"],

                 availableDays: ["Rabu", "Jumat"],

                 foodDescription: "Daging kambing bumbu krengsengan"

             ),

            FoodModel(

                 name: "Pindang Tulang", image: "pindang",

                 price: 22000, calories: 300, protein: 28, carbs: 12, fiber: 2, fat: 15,

                 isPopular: false, categories: ["Fish"],

                 availableDays: ["Selasa", "Kamis"],

                 foodDescription: "Ikan pindang kuah kuning"

             ),

            FoodModel(

                 name: "Rendang Telur", image: "rendang_telur",

                 price: 15000, calories: 250, protein: 14, carbs: 10, fiber: 2, fat: 15,

                 isPopular: true, categories: ["Egg"],

                 availableDays: ["Jumat"],

                 foodDescription: "Telur rendang bumbu Padang"

             ),

             FoodModel(

                 name: "Sate Usus", image: "sate_usus",

                 price: 12000, calories: 180, protein: 15, carbs: 5, fiber: 0, fat: 10,

                 isPopular: false, categories: ["Others"],

                 availableDays: ["Rabu"],

                 foodDescription: "Sate usus ayam bumbu kacang"

             ),



             // MARK: - Minuman

             FoodModel(

                 name: "Jus Jambu", image: "jus_jambu",

                 price: 10000, calories: 120, protein: 1, carbs: 28, fiber: 2, fat: 0,

                 isPopular: true, categories: ["Drinks"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Jus jambu merah segar"

             ),

             FoodModel(

                 name: "Es Teh Manis", image: "es_teh",

                 price: 5000, calories: 50, protein: 0, carbs: 12, fiber: 0, fat: 0,

                 isPopular: true, categories: ["Drinks"],

                 availableDays: ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"],

                 foodDescription: "Es teh manis segar"

             ),

             FoodModel(

                 name: "Kopi Susu", image: "kopi_susu",

                 price: 8000, calories: 80, protein: 2, carbs: 10, fiber: 0, fat: 3,

                 isPopular: true, categories: ["Drinks"],

                 availableDays: ["Senin", "Rabu", "Jumat"],

                 foodDescription: "Kopi susu gula aren"

             )
        ]
        for item in previewData {
            context.insert(item)
        }
        try context.save()
    }
}
