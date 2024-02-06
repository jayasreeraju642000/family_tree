import 'package:flutter_bloc/flutter_bloc.dart';
part 'details_pannel_visibility_state.dart';
class DetailsPanelVisibilityCubit extends Cubit<DetailsPannelVisibilityState> {
  static int lastVisitedNodeId = 0;
  static bool isPannelVisibile = false;

  DetailsPanelVisibilityCubit():super(DetailsPannelVisibilityState());
  void onVisibilityChange(int nodeId) {
    if (lastVisitedNodeId == nodeId) {
      isPannelVisibile = !isPannelVisibile;
    } else {
      isPannelVisibile = true;
    }
    lastVisitedNodeId = nodeId;
    emit(DetailsPannelVisibilityState(isPannelVisible: isPannelVisibile,lastViewedNodeId: lastVisitedNodeId));
  }
}
