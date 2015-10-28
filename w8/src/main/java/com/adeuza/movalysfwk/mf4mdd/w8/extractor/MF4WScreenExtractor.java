/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.w8.extractor;

import com.a2a.adjava.uml.UmlDictionary;
import com.a2a.adjava.uml2xmodele.extractors.ScreenExtractor;
import com.a2a.adjava.uml2xmodele.extractors.viewmodel.VMNamingHelper;
import com.a2a.adjava.utils.StrUtils;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MViewModelImpl;
import org.apache.commons.lang3.StringUtils;

public class MF4WScreenExtractor extends ScreenExtractor {

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void treatScreenRelations(UmlDictionary p_oUmlDict) throws Exception {

		// First bind each screen to its viewmodel
		IModelDictionary oDictionary = this.screenContext.getDomain().getDictionnary();
		String sSubPackageName = this.screenContext.getDomain().getLanguageConf().getViewModelImplementationSubPackageName();
		for (MScreen oScreen : oDictionary.getAllScreens()) {
			String sVmFullName = VMNamingHelper.getInstance().computeViewModelImplName(oScreen.getUmlName(), false,
					this.screenContext.getDomain().getLanguageConf());
			if ( sSubPackageName != null && !sSubPackageName.isEmpty()) {
				sVmFullName = StringUtils.join(sSubPackageName, StrUtils.DOT_S, sVmFullName);
			}
			sVmFullName = StringUtils.join(oScreen.getPackage().getFullName(), StrUtils.DOT_S, sVmFullName);

			MViewModelImpl oVm = oDictionary.getViewModel(sVmFullName);
			oVm.setScreenViewModel(true);
			oScreen.setViewModel(oVm);
		}
		// Treat screen relations
		MF4WScreenDependencyProcessor.getInstance().treatScreenRelations(this.screenContext, p_oUmlDict);
	}
}
