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

import java.util.ArrayList;

import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MCascade;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.adeuza.movalysfwk.mf4mdd.commons.extractor.DataLoaderExtractor;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;

/**
 * @author lmichenaud
 * 
 */
public class MF4WDataLoaderExtractor extends DataLoaderExtractor<MFDomain<MFModelDictionary,MFModelFactory>> {
	
	@Override
	public void extract(UmlModel p_oModele) throws Exception {
		super.extract(p_oModele);

		updateDataloadersCascadeForPhoto();
	}
	
	@SuppressWarnings("serial")
	private void updateDataloadersCascadeForPhoto() {
		for (MViewModelImpl oViewModel : this.getDomain().getDictionnary().getAllViewModels()) {
			for (MAttribute oAttr : oViewModel.getAttributes()) {
				if (oAttr.getTypeDesc().getShortName().equals("IMFPhotoViewModel")) {
					String sCascadeName = oViewModel.getEntityToUpdate().getName() + "Cascade." + oAttr.getName().toUpperCase();	
					String sCascadeImport = oViewModel.getEntityToUpdate().getMasterInterface().getFullName() + "Cascade";
					final MCascade oAttrCascade = new MCascade(sCascadeName, sCascadeImport, oViewModel.getEntityToUpdate(), oAttr.getName());
					
					if (((MFViewModel) oViewModel).getDataLoader() != null) {
						oViewModel.addLoadCascade(oAttrCascade);
						oViewModel.addSaveCascade(oAttrCascade);
						((MFViewModel) oViewModel).getDataLoader().addLoadCascade(new ArrayList<MCascade>() {{ add(oAttrCascade); }});
					} else {
						MFViewModel oParentVM = (MFViewModel) oViewModel.getParent();
						while (oParentVM != null) {
							if (oParentVM.getDataLoader() != null) {
								oParentVM.addLoadCascade(oAttrCascade);
								oParentVM.addSaveCascade(oAttrCascade);
								oParentVM.getDataLoader().addLoadCascade(new ArrayList<MCascade>() {{ add(oAttrCascade); }});
							}
							oParentVM = (MFViewModel) oParentVM.getParent();
						}
					}
				}
			}
		}
	}
}
