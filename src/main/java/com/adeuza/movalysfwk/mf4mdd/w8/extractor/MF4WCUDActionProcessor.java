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

import com.a2a.adjava.uml2xmodele.ui.screens.CUDActionProcessor;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.ui.component.MNavigationButton;
import com.a2a.adjava.xmodele.ui.panel.MPanelOperation;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;

public class MF4WCUDActionProcessor extends CUDActionProcessor {	
	
	@Override
	protected void addNavButton(MNavigationButton p_oNavButton, MPanelOperation p_oOperation, MPage p_oPage){
			// Test stereotype pour savoir où mettre le bouton : niveau list ou sur chaque item de la liste 
			// Si sur l'item, item le plus bas de la liste si liste à plusieurs niveaux.
			if(p_oPage.getViewModelImpl().getType() == ViewModelType.LIST_2){
				//TODO:Pour ajouter dans le listitem2open on passe par le listitem2 car l'autre n'est pas encore créé.
				p_oPage.getAdapter().getLayout("listitem2").addButton(p_oNavButton);
			}
			else{
				p_oPage.getLayout().addButton(p_oNavButton);
			}
	}
	
}
