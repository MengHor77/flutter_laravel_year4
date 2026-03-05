<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use App\Models\SpecialOffer;
use App\Models\FreeBookPDF;
use App\Models\Notification;  
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB; 

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        $notifications = [];
        $user = $request->user(); // យកព័ត៌មាន User ដែលកំពុង Login តាមរយៈ Sanctum

        // --- ១. រក្សាកូដចាស់ (ទាញយក Global Notifications ពី Tables ផ្សេងៗ) ---

        // ទាញទិន្នន័យពី Promotions (Special Offers)
        $offers = SpecialOffer::with('book')->where('is_active', true)->latest()->get();
        foreach ($offers as $offer) {
            $notifications[] = [
                'id' => 'promo_' . $offer->id,
                'title' => 'Special Offer: ' . $offer->discount_percentage . '% Off!',
                'message' => $offer->title . ' for ' . ($offer->book->name ?? 'book'),
                'type' => 'promotion',
                'target_id' => $offer->book_id,
                'created_at' => $offer->created_at,
                'is_read' => false, 
            ];
        }

        // ទាញទិន្នន័យពី Free PDF Books
        $freeBooks = FreeBookPDF::latest()->get();
        foreach ($freeBooks as $book) {
            $notifications[] = [
                'id' => 'free_' . $book->id,
                'title' => 'New Free E-book!',
                'message' => 'Download "' . $book->name . '" for free now.',
                'type' => 'free_pdf',
                'target_id' => $book->id,
                'created_at' => $book->created_at,
                'is_read' => false,
            ];
        }

        // --- ២. បន្ថែមកូដថ្មី (ទាញយកទិន្នន័យពី Table notifications សម្រាប់ User ម្នាក់ៗ) ---

        if ($user) {
            // ទាញយក Notification ដែលជារបស់ User ដែលកំពុង Login
            $userSpecificNotifs = Notification::where('user_id', $user->id)->latest()->get();
            foreach ($userSpecificNotifs as $notif) {
                $notifications[] = [
                    'id' => 'db_' . $notif->id, // ប្រើ Prefix 'db_' ដើម្បីសម្គាល់ថាវាជាទិន្នន័យក្នុង DB
                    'title' => $notif->title,
                    'message' => $notif->message,
                    'type' => $notif->type,
                    'target_id' => $notif->target_id,
                    'created_at' => $notif->created_at,
                    'is_read' => (bool)$notif->is_read,
                ];
            }
        }

        // រៀបលំដាប់តាមថ្ងៃខែ (ថ្មីបំផុតនៅខាងលើ)
        usort($notifications, function($a, $b) {
            // បំប្លែងទៅជា timestamp ដើម្បីប្រៀបធៀប
            $dateA = is_string($a['created_at']) ? strtotime($a['created_at']) : $a['created_at']->timestamp;
            $dateB = is_string($b['created_at']) ? strtotime($b['created_at']) : $b['created_at']->timestamp;
            return $dateB <=> $dateA;
        });

        return response()->json($notifications);
    }

    public function markAsRead(Request $request, $id)
    {
        // ប្រសិនបើ ID ផ្ដើមដោយ 'db_' យើងនឹង Update ទៅក្នុង Table notifications
        if (str_starts_with($id, 'db_')) {
            $realId = str_replace('db_', '', $id);
            $notification = Notification::find($realId);
            if ($notification) {
                $notification->update(['is_read' => true]);
            }
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Notification marked as read',
            'notification_id' => $id
        ], 200);
    }
}