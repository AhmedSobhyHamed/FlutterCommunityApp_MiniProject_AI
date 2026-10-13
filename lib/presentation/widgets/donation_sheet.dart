import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/responsive.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/validators.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/profile_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/primary_button.dart';

class DonationSheet extends StatefulWidget {
  const DonationSheet({super.key, required this.userId});

  final String userId;

  @override
  State<DonationSheet> createState() => _DonationSheetState();
}

class _DonationSheetState extends State<DonationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    final amount = double.parse(_amountController.text.trim());
    final saved = await context.read<ProfileCubit>().donate(
      userId: widget.userId,
      amount: amount,
    );
    if (!mounted) {
      return;
    }
    if (saved) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final isDonating = context.select<ProfileCubit, bool>((cubit) {
      final state = cubit.state;
      return state is ProfileReady && state.isDonating;
    });

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding(context),
        16,
        horizontalPadding(context),
        bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Donate',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Support the community. The amount is saved with your account.',
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: validateDonationAmount,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.volunteer_activism_outlined),
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Confirm donation',
              isLoading: isDonating,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
